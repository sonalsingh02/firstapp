class Api::V1::ErrorsController < Api::V1::BaseController
	def routing
	  raise ActionController::RoutingError.new(params[:path])
	end
end
