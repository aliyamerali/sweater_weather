class Api::V1::RoadtripController < ApplicationController
  def show
    login_error = Error.new('API Key Invalid', 'Invalid Credentials', 401)
    bad_params = Error.new('Must have a valid origin and destination', 'Invalid Request', 400)

    if invalid_credentials?
      render json: ErrorSerializer.new(login_error).serialized_json, status: :unauthorized
    elsif invalid_trip?
      render json: ErrorSerializer.new(bad_params).serialized_json, status: :bad_request
    else
      details = RoadtripFacade.get_roadtrip(params[:origin], params[:destination], params[:units])
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
