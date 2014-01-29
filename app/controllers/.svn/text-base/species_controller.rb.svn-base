class SpeciesController < ApplicationController
  # GET /species
  # GET /species.json
  def index
    @species = Species.companies_species(current_employee)
    @species = @species.sort_by! { |speci| [speci.name] }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @species }
    end
  end

  # GET /species/1
  # GET /species/1.json
  def show
    @species = Species.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @species }
    end
  end

  # GET /species/new
  # GET /species/new.json
  def new
    @employee = current_employee
    @species = Species.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @species }
    end
  end

  # GET /species/1/edit
  def edit
    @species = Species.find(params[:id])
  end

  # POST /species
  # POST /species.json
  def create
    @employee = current_employee
    @species = Species.new(params[:species])
    #All species should be captialized
    @species[:name] = proper_name(@species[:name])

    respond_to do |format|
      @extant_species = Species.find_by_name(@species.name)

      #If the Species doesn't already exist then create it.
      if @extant_species.nil?
        if @species.save
          @species.companies << @employee.company
          format.html { redirect_to @species, notice: 'Species was successfully created.' }
          format.json { render json: @species, status: :created, location: @species }
        else
          format.html { redirect_to @species, notice: 'Species could not be created.' }
          format.json { render json: @species, status: :created, location: @species }
        end
      else
        speciesNotAssociatedWithCompany = @extant_species.companies.find(@employee.company_id).nil?
        #If the species is a default species then it cannot be considered a custom species.
        if @extant_species.default?
          format.html { redirect_to @extant_species, notice: @extant_species.name + ' is a GoLumber default species and cannot be added to custom species.' }
          format.json { render json: @extant_species, status: :created, location: @species }
        elsif speciesNotAssociatedWithCompany
          @species.companies << @employee.company_id
          format.html { redirect_to @extant_species, notice: 'Species was successfully created.' }
          format.json { render json: @extant_species, status: :created, location: @species }
        else
          format.html { redirect_to @extant_species, notice: @extant_species.name + ' already exists as one of your custom species.' }
          format.json { render json: @extant_species, status: :created, location: @species }
        end
     end
    end #--end do
  end

  # PUT /species/1
  # PUT /species/1.json
  def update
    @species = Species.find(params[:id])

    respond_to do |format|
      if @species.update_attributes(params[:species])
        format.html { redirect_to @species, notice: 'Species was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @species.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /species/1
  # DELETE /species/1.json
  def destroy
    @species = Species.find(params[:id])
    CompaniesSpecies.destroy_all(:company_id => current_employee.company_id, :species_id => @species.id)
    
    @products = Product.where(:species_id => @species.id)
    #If a product exists using the custom species, then do not remove it from the species table
    #otherwise remove it from the species table.
    if @products.blank?
      @species.destroy
    end
    respond_to do |format|
      format.html { redirect_to species_index_url }
      format.json { head :no_content }
    end
  end
end
