class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  # :database_authenticatable, :recoverable
  devise :omniauthable, :registerable,
          :rememberable, :trackable, :validatable
end
