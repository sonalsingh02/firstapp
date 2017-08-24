class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :send_email
  has_many :galleries
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #def confirm!
   # welcome_message
    #super
  #end

  def password_required?
    new_record? ? false : super
  end

  def send_on_create_confirmation_instructions
  
  end

  private

  #def welcome_message
   # UserMailer.welcome_message(self).deliver
  #end
  def send_email
    self.update_attributes(:password => generate_password)
    AcknowledgementMailer.registration_mail(self).deliver_now
  end
  def generate_password
    password = Faker::Base.regexify(/[a-z]{2}[0-9]{7}[A-Z]{1}/)
  end
   
end