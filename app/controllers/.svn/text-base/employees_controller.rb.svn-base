class EmployeesController < ApplicationController
  before_filter :auth_employee, :except => [:create, :new]
  # GET /employees
  # GET /employees.json  
  def index
    @employees = Employee.accessible_by(current_ability, :index).limit(20)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employees }
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.json
  def new
    @employee = Employee.new

    respond_to do |format|
      format.html new.html.erb
      format.json { render json: @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
  end

  # POST /employees
  # POST /employees.json
  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        @employee = @company.employees.build(params[:employee])
        if @employee.save
          format.html { render action: "new" }
          format.json { render json: @employee, status: :created, location: @employee }
        else
          format.html { render :template => "devise/registrations/new" }
          format.json { render json: @employee.errors, status: :unprocessable_entity }          
        end
      else
        format.html { render :template => "devise/registrations/new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
    if !params[:logo][:photo].nil?
      @photo = @company.photos.build(params[:logo])
      @photo.save
    end
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = Employee.find(params[:id])

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    sign_out_and_redirect :employee
    #@employee = Employee.find(params[:id])
    #@employee.destroy

    #respond_to do |format|
    #  format.html { redirect_to home }#employees_url }
    #  format.json { head :no_content }
    #end
  end
end
