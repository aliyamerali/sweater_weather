class User < ApplicationRecord
  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true
  validates :api_key, uniqueness: true

  has_secure_password

  before_create do
    self[:api_key] = generate_unique_key
  end

  def generate_unique_key
    unique_key = SecureRandom.urlsafe_base64(27)
    while User.all.pluck(:api_key).include?(unique_key)
      unique_key = SecureRandom.urlsafe_base64(27)
    end
    unique_key
  end
end
