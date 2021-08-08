class User < ApplicationRecord
  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true
end
