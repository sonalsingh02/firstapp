class EmailSenderWorker
  include Sidekiq::Worker

	def perform(user_id,password)
		@user= User.find(user_id)
  		@password = password
  		#Sidekiq.logger("#{@user.inspect}*************")
		AcknowledgementMailer.registration_mail(@user,@password).deliver_later
  	end
end