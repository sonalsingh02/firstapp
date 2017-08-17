class Contact < ApplicationRecord
  after_create :send_email
  validates :name, presence: true
  validates :email, presence: true, format: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :mobilenumber, presence: true,numericality: true,length: { :minimum => 10, :maximum => 15 }
  validates :message ,presence: { message: "This field can't be left blank"}
  def contact_params
    params.require(:contact).permit(:name, :email, :mobilenumber, :message)
  end

  def send_email
    AcknowledgementMailer.thankyou_email(self).deliver_now
  end
end
