class Api::V1::RoadtripController < ApplicationController
  def show
    if User.all.pluck(:api_key).include?(params[:api_key])
      details = RoadtripFacade.get_roadtrip(params[:origin], params[:destination])
      render json: RoadtripSerializer.get_roadtrip(details[:roadtrip], details[:forecast])
    else
      render json: ErrorSerializer.login_error('Invalid Credentials'), status: :unauthorized
    end
  end
end
