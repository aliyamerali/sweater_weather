class Api::V1::SessionsController < ApplicationController
  def create
    email = params[:email].downcase
    user = User.find_by(email: email)
    error = 'Invalid Credentials'

    if user.nil?
      render json: ErrorSerializer.login_error(error), status: not_found
    elsif user.authenticate(params[:password])
      render json: UserSerializer.new(user)
    else
      render json: ErrorSerializer.login_error(error), status: :unauthorized
    end
  end
end
