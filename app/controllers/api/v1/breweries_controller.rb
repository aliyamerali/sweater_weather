class Api::V1::BreweriesController < ApplicationController
  def show
    location = params[:location]

    # get forecast
    forecast = ForecastFacade.get_forecast(location)
    summary = forecast.current_weather[:conditions]
    temperature = forecast.current_weather[:temperature]

    # get data from breweries api
    quantity = params[:quantity]
    lat_long_data = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    lat_long = "#{lat_long_data[:lat]},#{lat_long_data[:lng]}"
    breweries_data = BreweryService.find_breweries(lat_long, quantity)

    # create brewery objects
    breweries = breweries_data.map do |brewery|
      Brewery.new(brewery)
    end

    # send JSON response of serialized response
    render json: BrewerySerializer.find_breweries(location,forecast,breweries)
  end
end
