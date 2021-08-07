class Api::V1::BackgroundController < ApplicationController
  def show
    location = params[:location]
    weather_condition = ForecastFacade.get_forecast(location).current_weather[:conditions]
    time_of_day = time_of_day(Time.now.hour)
    images = ImageService.search(location+' '+weather_condition+' '+time_of_day)
    image = images[:results].sample
    image_object = Image.new(image, location)
    binding.pry
  end

  private
  def time_of_day(hour)
    if hour <= 5
      'night'
    elsif hour <= 12
      'morning'
    elsif hour <= 17
      'afternoon'
    elsif hour <= 22
      'evening'
    elsif hour <= 24
      'night'
    end
  end
end
