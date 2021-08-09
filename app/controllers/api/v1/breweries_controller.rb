class Api::V1::BreweriesController < ApplicationController
  def show
    location = params[:location]

    if location != '' && !location.nil?
      forecast = ForecastFacade.get_forecast(location)
      breweries = BreweryFacade.find_breweries(location, params[:quantity])
      render json: BrewerySerializer.find_breweries(location, forecast, breweries)
    else
      render json: { response: "Bad Request" }, status: :bad_request
    end
  end
end
