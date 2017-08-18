class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :galleries
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

def confirm!
    welcome_message
    super
  end

  # ...

private

  def welcome_message
    UserMailer.welcome_message(self).deliver
  end

end