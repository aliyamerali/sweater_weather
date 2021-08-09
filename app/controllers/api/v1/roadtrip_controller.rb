class Api::V1::RoadtripController < ApplicationController
  def show
    origin = params[:origin]
    destination = params[:destination]
    if User.all.pluck(:api_key).include?(params[:api_key])
      duration = secs_to_hrs_mins(RouteService.get_route(origin, destination)[:route][:time])
      # binding.pry
      #make roadtrip PORO
      #make destination_forecast PORO
      render json: RoadtripSerializer.get_roadtrip(roadtrip, destination_forecast)
    else
      render json: ErrorSerializer.login_error('Invalid Credentials'), status: :unauthorized
    end
  end

  def secs_to_hrs_mins(seconds)
    {
      hours: seconds / (60 * 60),
      minutes: (seconds / 60) % 60
    }
  end
end
