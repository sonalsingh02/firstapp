class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:create_user]

  def create_user
    @errors = []
    check_key
    validate_user_params(create_user_params) if @errors.empty?
    if @errors.empty?
      validated_params = [] 
      validated_params = create_user_params
      validated_params[:email] = validated_params[:email].to_s.strip
      user = User.new(validated_params)
      if user.save
        render json: { status: "Success", message: "User created successfully", code: 200 }
      else
        render json: { status: "Failure", message: user.errors.full_messages, code: 500 } #model validations
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

  def create_user_params
    params.require(:user).permit(:email)
  end

  def validate_email(str)
    str[/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i]  == str
  end

  def validate_user_params params
   unless params[:email].to_s.strip.empty?
      if !validate_email(params[:email].to_s.strip)
        @errors << "Email is invalid"
      end
    else
       @errors << "Email is empty"
    end
  end

  def check_key
    if(!params.has_key?(:email))
      @errors << "Email key is missing"
    end
  end
end