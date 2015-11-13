class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :full_name, presence: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :email, presence: true, uniqueness: true
end