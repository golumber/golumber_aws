class GradesController < ApplicationController
  # GET /grades
  # GET /grades.json
  def index
    @grades = Grade.companies_grades(current_employee)
    @grades = @grades.sort_by! { |grad| [grad.name] }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grades }
    end
  end

  # GET /grades/1
  # GET /grades/1.json
  def show
    @grade = Grade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grade }
    end
  end

  # GET /grades/new
  # GET /grades/new.json
  def new
    @employee = current_employee
    @grade = Grade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grade }
    end
  end

  # GET /grades/1/edit
  def edit
    @grade = Grade.find(params[:id])
  end

  # POST /grades
  # POST /grades.json
  # See Document For Overview of Grades
  def create
    @employee = current_employee
    @grade = Grade.new(params[:grade])
    @grade[:name] = proper_name(@grade[:name])

    respond_to do |format|
      @grade_exist = Grade.find_by_name(@grade.name)

      #If the grade doesn't already exist then create it.
      if @grade_exist.nil?
        if @grade.save
          @comp_grade_exist = CompaniesGrade.find_by_company_id_and_grade_id(@employee.company_id, @grade.id)
          #If the company grade doesen't already exist then create it
          if @comp_grade_exist.nil?
            CompaniesGrade.create(:company_id => @employee.company_id, :grade_id => @grade.id)
            format.html { redirect_to @grade, notice: 'grade was successfully created.' }
            format.json { render json: @grade, status: :created, location: @grade }
          else
            format.html { redirect_to @grade, notice: 'grade already exists.' }
            format.json { render json: @grade, status: :created, location: @grade }
          end
        else
          format.html { render action: "new" }
          format.json { render json: @grade.errors, status: :unprocessable_entity }
        end
      else
        @comp_grade_exist = CompaniesGrade.find_by_company_id_and_grade_id(@employee.company_id, @grade_exist.id)
        #If the grade is a default grade then it cannot be considered a custom grade.
        if @grade_exist.default?
          format.html { redirect_to @grade_exist, notice: @grade_exist.name + ' is a GoLumber default grade and cannot be added to custom grade.' }
          format.json { render json: @grade_exist, status: :created, location: @grade }
        elsif @comp_grade_exist.nil?
          CompaniesGrade.create(:company_id => @employee.company_id, :grade_id => @grade_exist.id)
          format.html { redirect_to @grade_exist, notice: 'grade was successfully created.' }
          format.json { render json: @grade_exist, status: :created, location: @grade }
        else
          format.html { redirect_to @grade_exist, notice: @grade_exist.name + ' already exists as one of your custom grades.' }
          format.json { render json: @grade_exist, status: :created, location: @grade }
        end
     end
    end #--end do
  end

  # PUT /grades/1
  # PUT /grades/1.json
  def update
    @grade = Grade.find(params[:id])

    respond_to do |format|
      if @grade.update_attributes(params[:grade])
        format.html { redirect_to @grade, notice: 'Grade was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1
  # DELETE /grades/1.json
  def destroy
    @grade = Grade.find(params[:id])
    CompaniesGrade.destroy_all(:grade_id => @grade.id, :company_id => current_employee.company_id)

    @products = Product.where(:grade_id => @grade.id)
    @companies = CompaniesGrade.where(:grade_id => @grade.id)
    #If a product exists using the grade, or if another company is using the grade,
    #then do not remove it from the grade table, otherwise remove it from the grade table.
    if @products.blank? and @companies.blank?
      @grade.destroy
    end
    respond_to do |format|
      format.html { redirect_to grades_url }
      format.json { head :no_content }
    end
  end
end
