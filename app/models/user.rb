class User < ApplicationRecord
  has_many :galleries
  after_create :send_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def password_required?
    new_record? ? false : super
  end

  private

  def send_email
    self.update_attributes(:password => generate_password)
    AcknowledgementMailer.registration_mail(self).deliver_now
  end

  def generate_password
    Faker::Base.regexify(/[a-z]{2}[0-9]{7}[A-Z]{1}/)
  end
end
