class Api::V1::ForecastController < ApplicationController
  def show
    location = params[:location] #eg "denver,co"
    # Convert city/state to lat/long (Mapquest API)
    # response = Faraday.get "http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['GEOCODE_API_KEY']}&location=#{location}"
    # lat_long = JSON.parse(response.body, symbolize_names: true)[:results].first[:locations].first[:latLng]
    lat_long = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    # binding.pry
    # Retrieve Forecast data for lat/long (OpenWeather API)
    # Serialize response to match output
  end
end
