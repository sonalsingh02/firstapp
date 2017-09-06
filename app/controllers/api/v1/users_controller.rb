class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:create_user]

  def create_user
    @errors = []
    validate_user_params(create_user_params)
    if @errors.empty?
      user = User.new(create_user_params)
      if user.save
        render json: { status: "Success", message: "Successful", code: 200 }
      else
        render json: { status: "Failure", message: user.errors.full_messages, code: 500 }
      end
    else
       render json: { status: "Failure", message: @errors, code: 500 }
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
    if params[:email] != ""
      if !validate_email(params[:email])
        @errors << "Email is invalid"
      end
    else
       @errors << "Email is empty"
    end
  end
end