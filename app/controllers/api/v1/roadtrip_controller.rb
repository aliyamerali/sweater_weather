class Api::V1::RoadtripController < ApplicationController
  def show
    if invalid_credentials?
      render json: ErrorSerializer.login_error('Invalid Credentials'), status: :unauthorized
    elsif invalid_trip?
      render json: ErrorSerializer.login_error('Invalid Request'), status: :bad_request
    else
      details = RoadtripFacade.get_roadtrip(params[:origin], params[:destination])
      render json: RoadtripSerializer.get_roadtrip(details[:roadtrip], details[:forecast])
    end
  end

  private

  def invalid_trip?
    origin = params[:origin]
    destination = params[:destination]
    (origin == '' || origin.nil?) || (destination == '' || destination.nil?)
  end

  def invalid_credentials?
    !User.all.pluck(:api_key).include?(params[:api_key])
  end
end
