require 'securerandom'

class Api::V1::UsersController < ApplicationController
  def create
    user = user_params
    user[:email] = user[:email].downcase
    user[:api_key] = SecureRandom.urlsafe_base64(27)
    new_user = User.create(user)
    if new_user.save
      render json: UserSerializer.new(new_user)
    else
      render json: { response: new_user.errors }, status: :bad_request
    end
  end

  private
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
