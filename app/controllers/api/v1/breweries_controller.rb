class Api::V1::BreweriesController < ApplicationController
  def show
    location = params[:location]

    # get data from breweries api
    quantity = params[:quantity]
    lat_long_data = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    lat_long = "#{lat_long_data[:lat]},#{lat_long_data[:lng]}"
    breweries = BreweryService.find_breweries(lat_long, quantity)

    # get forecast
    forecast = ForecastFacade.get_forecast(location)
    summary = forecast.current_weather[:conditions]
    temperature = forecast.current_weather[:temperature]

    # create brewery objects


    # serialize response
    # send JSON response
  end
end
