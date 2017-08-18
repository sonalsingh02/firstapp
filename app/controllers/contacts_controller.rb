class ContactsController < ApplicationController

  def new
  	@contact = Contact.new
  end

  def create
  	@contact = Contact.new(contact_params)
    if @contact.save
     	redirect_to contacts_new_path, notice: 'We have received your query.We will get back to you shortly'
    else
    	render 'new'
    end
  end

  private
	def contact_params
    	params.require(:contact).permit(:name, :email, :mobile_number, :message)
  	end
end

 
