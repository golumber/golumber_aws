class ConfirmationMailer < ActionMailer::Base

  default :from => "noreply@golumber.com"
  default :to => "you@youremail.dev"

  def confirmation_instructions(employee)
    @employee = employee
    @url  = "http://golumber.com/login"
    mail(:to => employee.email, :subject => "Welcome to GoLumber.com")
  end

end