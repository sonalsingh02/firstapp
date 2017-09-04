class Api::V1::BaseController < ActionController::API
	protect_from_forgery with: :null_session
	before_action :authenticate_user! 
	before_action :destroy_session
	
	def destroy_session
    	request.session_options[:skip] = true
  	end
end