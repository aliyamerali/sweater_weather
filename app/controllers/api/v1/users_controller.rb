require 'securerandom'
class Api::V1::UsersController < ApplicationController
  def create
    user = user_params
    update_user_attributes(user)
    new_user = User.create(user)
    if new_user.save
      render json: UserSerializer.new(new_user), status: :created
    else
      render json: { response: new_user.errors }, status: :bad_request
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def update_user_attributes(user)
    user[:email] = user[:email].downcase
    user[:api_key] = generate_unique_key
  end

  def generate_unique_key
    unique_key = SecureRandom.urlsafe_base64(27)
    while User.all.pluck(:api_key).include?(unique_key)
      unique_key = SecureRandom.urlsafe_base64(27)
    end
    unique_key
  end
end
