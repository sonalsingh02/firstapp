class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :send_email
  has_many :galleries
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  def password_required?
    new_record? ? false : super
  end

  private

  def send_email
    @password = generate_password
    self.update_attributes(:password => generate_password)
    after_transaction do
      EmailSenderWorker.perform_async(self.id, @password)
    end
  end

  def generate_password
    password = Faker::Base.regexify(/[a-z]{2}[0-9]{7}[A-Z]{1}/)
  end
   
end

