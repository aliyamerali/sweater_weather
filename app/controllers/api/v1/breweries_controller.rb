class Api::V1::BreweriesController < ApplicationController
  def show
    location = params[:location]

    forecast = ForecastFacade.get_forecast(location)
    breweries = BreweryFacade.find_breweries(location, params[:quantity])

    render json: BrewerySerializer.find_breweries(location, forecast, breweries)
  end
end
