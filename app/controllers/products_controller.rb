class ProductsController < ApplicationController
	before_filter :auth_employee
	#has ability requires the company_id so use the product to find the company id
	before_filter( :only => [:edit, :delete, :show]) { |c| c.has_ability Product.where(:id => params[:id]).first.company_id }

	def search
		@species = Species.joins(:products).where('products.is_active' => true).select("distinct(species.id), species.name")
		@results_tag = "Featured"
		@products = Product.all.sort_by { rand }.slice(1,15)
		@products = @products.sort_by! { |product| [
			product.species.name, product.thickness_metric,
			product.width_metric, (product.grade.name).reverse] }
	end
	
	def update_search_selects
		if params["species"].nil?
			@species = Species.joins(:products).where('products.is_active' => true).select("distinct(species.id), species.name")
		else
			@imperial = params["imperial"] == 'true'
			@selected_species = params["species"].to_i
			if params["thickness"].nil?
				if @imperial
					@thicknesses_imperial = Product.where('species_id = ? AND thickness_imperial != ""', @selected_species)
					 															.select("distinct(thickness_imperial) as distinct_thickness, 'imperial' as type")
					@thicknesses_actual = Product.where('species_id = ? AND thickness_imperial = ""', @selected_species)
																				.select("distinct(thickness_actual) as distinct_thickness, 'actual' as type")
					@thicknesses = @thicknesses_imperial + @thicknesses_actual
				else
					@thicknesses = Product.where(:species_id => @selected_species).select("distinct(thickness_metric) as distinct_thickness, 'metric' as type")
				end
			else
				@selected_thickness = params["thickness"]
				@selected_thickness_type = params["thickness_type"]
				if params["width"].nil?
					if @imperial
						@widths_imperial = Product.where('species_id = %s AND thickness_%s = %s AND width_imperial != ""', @selected_species, @selected_thickness_type, @selected_thickness)
																					.select("distinct(width_imperial) as distinct_width, 'imperial' as type")
						@widths_actual = Product.where('species_id = %s AND thickness_%s = %s AND width_imperial = ""', @selected_species, @selected_thickness_type, @selected_thickness)
																					.select("distinct(width_actual) as distinct_width, 'actual' as type")
						@widths = @widths_imperial + @widths_actual
					else
						@widths = Product.where(:species_id => @selected_species, :thickness_metric => @selected_thickness).select("distinct(width_metric) as distinct_width, 'metric' as type")
					end
				else
					@selected_width = params["width"]
					@selected_width_type = params["width_type"]
					@grades = Product.joins(:grade).where("species_id = %s AND thickness_%s = %s AND width_%s = %s", @selected_species, @selected_thickness_type, @selected_thickness, @selected_width_type, @selected_width).select("distinct(grades.id), grades.name")
				end
			end
		end
		respond_to do |format|
			 format.js
		end
	end
	
	def table
		@employee = current_employee
    @company = @employee.company
		@imperial = params["imperial"] == 'true'
		@activityColumn = false
		@search = params["search"] == 'true'
		if @search
      @results_tag = "Results"
			@products = Product.where("species_id = %s AND thickness_%s = %s AND width_%s = %s AND grade_id = %s", params["species"], params["thickness_type"], params["thickness"], params["width_type"], params["width"], params["grade"])
		else
			case params["display"]
				when "all"
					@products = @company.products
					@activityColumn = true
				when "active"
					@products = @company.products.where(:is_active => true)
				else
					@products = @company.products.where(:is_active => false)
			end
			@products = @products.sort_by! {
				|product| [product.species.name, product.thickness_metric, 
				product.width_metric, (product.grade.name).reverse] }
		end
		respond_to do |format|
			format.js
		end
	end

	# GET /products
	# GET /products.json
	def index
		@employee = current_employee
		@company = @employee.company
		@products = Product.where(:company_id => @company.id)
		@products = @products.sort_by! { |product| [product.species.name, product.thickness_metric, 
																								product.width_metric,
																								(product.grade.name).reverse] }
		@company_employee = Employee.where(:company_id => @company.id).first
		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @products }
		end
	end

	# GET /products/1
	# GET /products/1.json
	def show
		@product = Product.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @product }
		end
	end

	# GET /products/new
	# GET /products/new.json
	def new
		@product = Product.new
		@company = current_employee.company
		@product.photos.build

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @product }
		end
	end

	# GET /products/1/edit
	def edit
		@product = Product.find(params[:id])
		@product.photos.build
		@company = @product.company
	end

	# POST /products
	# POST /products.json
	def create
		# add the company id to the associated product
		@product = Product.new
		@company = current_employee.company
		if params[:random_width]
			params[:product][:width_imperial] = 0
			params[:product][:width_actual] = 0
			params[:product][:width_metric] = 0
		end
		newParams = params[:product].merge(:company_id => current_employee.company_id)
		unit = params[:unit]
		if unit == "metric"
			@product.validateMetric(newParams)
		else
			@product.validateImperial(newParams)
		end
		respond_to do |format|
			if not(@product.errors.blank?)
				@product.photos.build
				@product.attributes = newParams #Sends the filled in fields to be rendered with the errors
				format.html { render action: "new" }
				format.json { render json: @product.errors, status: :unprocessable_entity }
			else
				if unit == "metric"
					final_params = @product.convertProductToImperial(newParams)
				else
					final_params = @product.convertProductToMetric(newParams)
				end
				@product.attributes = final_params
				if @product.update_attributes(final_params)
					format.html { redirect_to products_url, notice: 'Product was successfully created.' }
					format.json { render json: @product, status: :created, location: @product }
				else
					format.html { render action: "new" }
					format.json { render json: @product.errors, status: :unprocessable_entity }
				end
			end
		end #end do
		if (params[:product][:photos_attributes])
			params[:product][:photos_attributes].each do |photo_attributes_array|
				photo_attributes = photo_attributes_array[1]
				if !photo_attributes[:photo].nil?
					@photo = @product.photos.build(photo_attributes)
					@photo.save
				end
			end		
		end
	end

	# PUT /products/1
	# PUT /products/1.json
	def update
		@product = Product.find(params[:id])
		newParams = params[:product].merge(:company_id => current_employee.company_id)
		unit = params[:unit]
		if unit == "metric"
			@product.validateMetric(newParams)
		else
			@product.validateImperial(newParams)
		end

		respond_to do |format|
			if not(@product.errors.blank?)
				@product.attributes = newParams #Sends the filled in fields to be rendered with the errors
				format.html { render action: "edit" }
				format.json { render json: @product.errors, status: :unprocessable_entity }
			else
				if unit.to_s == "metric"
					final_params = @product.convertProductToImperial(newParams)
				elsif unit.to_s == "imperial"
					final_params = @product.convertProductToMetric(newParams)
				end
				@product.attributes = final_params
				if @product.update_attributes(final_params)
					format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
					format.json { head :no_content }
				else
					format.html { render action: "edit" }
					format.json { render json: @product.errors, status: :unprocessable_entity }
				end
			end
		end #end do
		if(params[:product][:photos_attributes])
			params[:product][:photos_attributes].each do |photo_attributes_array|
				photo_attributes = photo_attributes_array[1]
				if !photo_attributes[:photo].nil?
					@photo = @product.photos.build(photo_attributes)
					@photo.save
				end
			end		
		end
	end
	
	# DELETE /products/1
	# DELETE /products/1.json
	def destroy
		@product = Product.find(params[:id])
		@product.destroy

		respond_to do |format|
			format.html { redirect_to products_url }
			format.json { head :no_content }
		end
	end
end
