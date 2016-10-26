# User class used by devise
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  # :omniauthable, :recoverable
  devise :database_authenticatable,
    :rememberable, :trackable, :validatable

end
