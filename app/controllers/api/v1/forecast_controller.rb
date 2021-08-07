class Api::V1::ForecastController < ApplicationController
  def show
    location = params[:location] # eg "denver,co"
    lat_long = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    # binding.pry
    # Retrieve Forecast data for lat/long (OpenWeather API)
    # Serialize response to match output
  end
end
