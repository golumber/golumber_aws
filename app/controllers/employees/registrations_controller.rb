class Employees::RegistrationsController < Devise::RegistrationsController
  before_filter :check_permissions, :only => [:new, :create, :cancel]
  skip_before_filter :require_no_authentication
  skip_before_filter :auth_employee
  
 
  def check_permissions
    #authorize! :create, resource
  end
  def new
    super
    @company = Company.new
  end
  
  def create
    if verify_recaptcha
        super
        flash.delete(:recaptcha_error)
    else
        build_resource
        clean_up_passwords(resource)
        flash.delete(:recaptcha_error)
        flash[:alert] = "Typed keyword is not correct!"
        render :template => '/registrations/new' 
    end
  end
  
  def createNewCompany
      if params[:commit] == 'Sign up'
          # A was pressed 
      elsif params[:commit] == 'Save and Continue'
          params[:company_id] = 688263874
          redirect_to '/companies/new'
      end
  end
  
end