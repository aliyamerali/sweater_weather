class Api::V1::SessionsController < ApplicationController
  @@login_error = Error.new('API Key Invalid','Invalid Credentials', 401)

  def create
    email = params[:email].downcase
    user = User.find_by(email: email)
    error = 'Invalid Credentials'

    if user.nil?
      render json: ErrorSerializer.new(@@login_error).serialized_json, status: :unauthorized
    elsif user.authenticate(params[:password])
      render json: UserSerializer.new(user)
    else
      render json: ErrorSerializer.new(@@login_error).serialized_json, status: :unauthorized
    end
  end
end
