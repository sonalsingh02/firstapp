class User < ApplicationRecord
<<<<<<< HEAD
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :send_email
  has_many :galleries
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  
=======
  has_many :galleries
  after_create :send_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

>>>>>>> d60ebda7dd4355b1edf94bb707631764016bc6b6
  def password_required?
    new_record? ? false : super
  end

  private

  def send_email
    self.update_attributes(:password => generate_password)
    AcknowledgementMailer.registration_mail(self).deliver_now
  end
<<<<<<< HEAD
  def generate_password
    password = Faker::Base.regexify(/[a-z]{2}[0-9]{7}[A-Z]{1}/)
  end
   
end
=======

  def generate_password
    Faker::Base.regexify(/[a-z]{2}[0-9]{7}[A-Z]{1}/)
  end
end
>>>>>>> d60ebda7dd4355b1edf94bb707631764016bc6b6
