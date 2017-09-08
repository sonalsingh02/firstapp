class ApplicationController < ActionController::Base
  before_action :authenticate_user! 
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  rescue_from ActionController::RoutingError do |exception|
 		logger.error 'Routing error occurred'
 		render json: { :status => "Failure", :message => "Page Not Found", :code => 500 }
	end 

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end
end
