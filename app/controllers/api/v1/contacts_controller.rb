class Api::V1::ContactsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:send_message]

  def send_message
    contact = Contact.new(contact_params)
    if contact.save
      render json: { status: "Success", message: "Successful", code: 200 }
    else
      render json: { status: "Failure", message: contact.errors.full_messages, code: 500 }
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :mobile_number, :message)
  end
end