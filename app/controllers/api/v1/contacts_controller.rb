class Api::V1::ContactsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:send_message]

  def send_message
    @errors = []
    validate_contact_params(contact_params)
    if @errors.empty?
      contact = Contact.new(contact_params)
      if contact.save
        render json: { status: "Success", message: "Successful", code: 200 }
      else
        render json: { status: "Failure", message: contact.errors.full_messages, code: 500 }
      end
    else
      if @errors.length == 1
        render json: { status: "Failure", message: @errors, code: 500 }
      else
        message = ""
        @errors.each do |e|
          message += e + ";"
        end
        render json: { :status => "Failure", :message => message, :code => 500 }
      end
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :mobile_number, :message)
  end

  def all_letters_or_digits(str)
    str[/[a-zA-Z0-9]+/]  == str
  end

  def validate_email(str)
    str[/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i]  == str
  end

  

   def validate_contact_params params
    if params[:name] != ""
      if !all_letters_or_digits(params[:name])
        @errors << "Name is invalid"
      end
    else
       @errors << "Name is empty"
    end
    if params[:email] != ""
      if !validate_email(params[:email])
        @errors << "Email is invalid"
      end
    else
       @errors << "Email is empty"
    end
    if params[:mobile_number] == ""
      @errors << "Mobile Number is empty"
    end
    if params[:message] == ""
       @errors << "Message is empty"
    end
  end
end