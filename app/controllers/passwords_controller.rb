class PasswordsController < ApplicationController
  skip_before_filter :auth_employee
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
end