class AcknowledgementMailer < ApplicationMailer
	def thankyou_email(contact)
	    @contact = contact
	    mail(to: @contact.email, subject: 'Thank You For Contacting Us')
  	end

 	def registration_mail(user,password)
 		@user = user
 		@password = password
 		mail(to: @user.email, subject: 'You have successsfully registered with us')
  	end
end