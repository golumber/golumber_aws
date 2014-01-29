class PrivacyController < ApplicationController
  skip_before_filter :auth_employee
end
