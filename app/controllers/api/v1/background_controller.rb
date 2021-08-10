class Api::V1::BackgroundController < ApplicationController
  def show
    image = ImageFacade.get_image(params[:location])
    if image.instance_of?(Error)
      render json: ErrorSerializer.new(image).serialized_json, status: :bad_request
    else
      render json: ImageSerializer.new(image)
    end
  end
end
