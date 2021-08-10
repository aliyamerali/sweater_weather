require 'securerandom'
class Api::V1::UsersController < ApplicationController
  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.create(user)
    if new_user.save
      render json: UserSerializer.new(new_user), status: :created
    else
      error = Error.new(new_user.errors.messages, 'Invalid Request', 400)
      render json: ErrorSerializer.new(error).serialized_json, status: :bad_request
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
