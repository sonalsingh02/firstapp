class RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)
    if resource.save
      sign_out resource
      set_flash_message :notice, :signup_confirm
      redirect_to new_user_session_path
    else
      set_flash_message :notice, :signup_error
      redirect_to new_user_registration_path
    end
  end
  private 
  def registration_params
    params.require(:user).permit(:email)
  end
end