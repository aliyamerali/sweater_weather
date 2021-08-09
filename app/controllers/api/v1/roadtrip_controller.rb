class Api::V1::RoadtripController < ApplicationController
  def show
    origin = params[:origin]
    destination = params[:destination]
    if User.all.pluck(:api_key).include?(params[:api_key])
      duration = secs_to_hrs_mins(RouteService.get_route(origin, destination)[:route][:time])
      roadtrip = Roadtrip.new(origin, destination, duration)

      #get forecast
      lat_long = GeocodeService.lat_long(destination)[:results].first[:locations].first[:latLng]
      lat = lat_long[:lat]
      long = lat_long[:lng]
      weather = WeatherService.forecast(lat, long)

      #make destination_forecast PORO
      destination_forecast = DestinationForecast.new(weather, duration)
      
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
