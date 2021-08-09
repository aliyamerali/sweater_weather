class Api::V1::SessionsController < ApplicationController
  def create
    email = (params[:email]).downcase
    user = User.find_by(email: email)

    if user.nil?
      error = "Invalid Credentials"
      render json: ErrorSerializer.login_error(error), status: 404
    elsif user.authenticate(params[:password])
      render json: UserSerializer.new(user)
    else
      error = "Invalid Credentials"
      render json: ErrorSerializer.login_error(error), status: 401
    end
  end
end
