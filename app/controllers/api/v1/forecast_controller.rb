class Api::V1::ForecastController < ApplicationController
  def show
    forecast = ForecastFacade.get_forecast(params[:location], params[:units])
    if forecast.instance_of?(Error)
      render json: ErrorSerializer.new(forecast).serialized_json, status: :bad_request
    else
      render json: ForecastSerializer.new(forecast)
    end
  end
end
