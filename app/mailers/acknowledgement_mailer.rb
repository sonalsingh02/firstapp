class AcknowledgementMailer < ApplicationMailer
	def thankyou_email(contact)
	    @contact = contact
	    mail(to: @contact.email, subject: 'Thank You For Contacting Us')
  end
end
