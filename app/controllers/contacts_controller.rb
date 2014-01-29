class ContactsController < ApplicationController
  skip_before_filter :auth_employee
  def index
      @message = Message.new
    end
  def new
    @contacts = Contacts.new
  end
  
  def create
    begin
      @contacts = Contacts.new(params[:contact_form])
      @contacts.request = request
      if @contacts.deliver
        flash.now[:notice] = 'Thank you for your message!'
      else
        render :new
      end
    rescue ScriptError
      flash[:error] = 'Sorry, this message appears to be spam and was not delivered.'
    end
  end
end
