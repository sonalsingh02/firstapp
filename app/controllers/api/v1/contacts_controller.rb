class Api::V1::ContactsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:send_message]

  def send_message
    @errors = []
    check_key
    validate_contact_params(contact_params) if @errors.empty?
    if @errors.empty?
      validated_params = [] 
      validated_params = contact_params
      #Rails.logger.info("****#{upload_params[:name].strip}*********")
      validated_params[:name] = validated_params[:name].to_s.strip
      validated_params[:email] = validated_params[:email].to_s.strip
      validated_params[:mobile_number] = validated_params[:mobile_number].to_s.strip
      validated_params[:message] = validated_params[:message].to_s.strip
      contact = Contact.new(validated_params)
      if contact.save
        render json: { status: "Success", message: "Message sent successfully", code: 200 }
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
    str[/\A[a-zA-Z0-9\s]+\Z/i]  == str
  end

  def validate_email(str)
    str[/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i]  == str
  end

  

  def validate_contact_params params
    unless params[:name].to_s.strip.empty?
      if !all_letters_or_digits(params[:name].to_s.strip)
        @errors << "Name is invalid"
      end
    else
       @errors << "Name is empty"
    end
    unless params[:email].to_s.strip.empty?
      if !validate_email(params[:email].to_s.strip)
        @errors << "Email is invalid"
      end
    else
       @errors << "Email is empty"
    end
    if params[:mobile_number].to_s.strip.empty?
      @errors << "Mobile Number is empty"
    end
    if params[:message].to_s.strip.empty?
       @errors << "Message is empty"
    end
  end

  def check_key
    if(params.has_key?(:name) && params.has_key?(:email) && params.has_key?(:mobile_number) && !params.has_key?(:message))
      @errors << "Message id key is missing"
    elsif(params.has_key?(:name) && params.has_key?(:email) && !params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Mobile Number key is missing"
    elsif(params.has_key?(:name) && !params.has_key?(:email) && params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Email key is missing"
    elsif(!params.has_key?(:name) && params.has_key?(:email) && params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Name key is missing"
    elsif(params.has_key?(:name) && params.has_key?(:email) && !params.has_key?(:mobile_number) && !params.has_key?(:message))
      @errors << "Mobile Number and Message key is missing"
    elsif(params.has_key?(:name) && !params.has_key?(:email) && !params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Email and Mobile Number key is missing"
    elsif(params.has_key?(:name) && !params.has_key?(:email) && params.has_key?(:mobile_number) && !params.has_key?(:message))
        @errors << "Message and email key is missing"
    elsif(!params.has_key?(:name) && !params.has_key?(:email) && params.has_key?(:mobile_number) && params.has_key?(:message))
        @errors << "Name and email key is missing"
    end
  end
end