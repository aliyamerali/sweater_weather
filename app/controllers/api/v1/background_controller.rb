class Api::V1::BackgroundController < ApplicationController
  def show
    image = ImageFacade.get_image(params[:location])
    render json: ImageSerializer.new(image)
  end
end
