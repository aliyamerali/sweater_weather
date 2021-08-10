class Api::V1::RoadtripController < ApplicationController
  def show
    origin = params[:origin]
    destination = params[:destination]

    # Add conditional for origin + destination being valid entries
    if User.all.pluck(:api_key).include?(params[:api_key])
      details = RoadtripFacade.get_roadtrip(origin, destination)
      render json: RoadtripSerializer.get_roadtrip(details[:roadtrip], details[:forecast])
    else
      render json: ErrorSerializer.login_error('Invalid Credentials'), status: :unauthorized
    end
  end
end
