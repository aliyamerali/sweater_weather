class User < ApplicationRecord
  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true

  has_secure_password
end
