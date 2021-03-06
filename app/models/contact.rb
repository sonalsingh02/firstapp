class Contact < ApplicationRecord
  after_create :send_email
  validates :name, presence: true
  validates :email, presence: true, format: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :mobile_number, presence: true,numericality: true,length: { :minimum => 10, :maximum => 15 }
  validates :message ,presence: { message: "This field can't be left blank"}

  def send_email
  	after_transaction do
      EmailSenderContactWorker.perform_async(self.id)
    end
  end
end
