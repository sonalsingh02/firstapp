class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:create_user]

  def create_user
    user = User.new(create_user_params)
    if user.save
      render json: { status: "Success", message: "Successful", code: 200 }
    else
      render json: { status: "Failure", message: user.errors.full_messages, code: 500 }
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:email)
  end
end