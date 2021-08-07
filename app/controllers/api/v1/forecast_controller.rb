class Api::V1::ForecastController < ApplicationController
  def show
    location = params[:location] # eg "denver,co"\
    ###
    # move to a facade - get lat long, get weather, create forecase object
    lat_long = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    lat = lat_long[:lat]
    long = lat_long[:lng]
    weather = WeatherService.forecast(lat, long)
    forecast = Forecast.new(weather)
    ###
    # Serialize response to match output
    render json: ForecastSerializer.new(forecast)

  end
end
