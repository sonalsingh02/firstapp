class EmailSenderContactWorker
  include Sidekiq::Worker

  def perform(contact_id)
		@contact = Contact.find(contact_id)
		AcknowledgementMailer.thankyou_email(@contact).deliver_later
  	end
end
