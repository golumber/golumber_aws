class ApplicationController < ActionController::Base
  #Not sure what these methods are, likely used with the devise plugin
  protect_from_forgery
  after_filter :store_location
  
  def store_location
    # store last url as long as it isn't /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/employees/
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  # Used in the controller to ensure that a user is logged in before allowing them to view 
  # certain pages within GoLumber
  def auth_employee
    redirect_to '/login', :notice => "Please login to have full access to GoLumber" unless employee_signed_in?
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  
  # Used in controllers to ensure that a user does not make http calls to edit/delete
  # other company information
  # @param company_id - the id of the company which a user is attempting to modify
  #        some attribute of. (ex. editing a product, company information..)
  def has_ability(company_id)
      redirect_to '/', :notice => "You only have permission to edit your company information." unless current_employee.can_manage?(company_id)
  end
  
  def is_numeric?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
  
  # For all proper names input into the website, strip them of whitespace
  #     and capitalize them.
  # @param: name - should be the string to be capitalized and rid of whitespace
  def proper_name(name)
    name = name.strip
    name = name.capitalize
    return name
  end
  
  private
    
    #def after_sign_out_path_for(resource_or_scope)
    #  redirect_to root_path
    #end
  
end

#class PostsController < ApplicationController
#  before_filter :require_user # require_user will set the current_user in controllers
#  before_filter :set_current_user
#end
