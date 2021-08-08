class ImageFacade
  def self.get_image(location)
    weather_conditions = ForecastFacade.get_forecast(location).current_weather[:conditions]
    time_of_day = time_of_day(Time.current.hour)
    images = ImageService.search("#{location} #{weather_conditions} #{time_of_day}")
    image_data = images[:results].sample
    Image.new(image_data, location)
  end

  def self.time_of_day(hour)
    if hour <= 5 || (hour <= 24 && hour > 22)
      'night'
    elsif hour <= 12
      'morning'
    elsif hour <= 17
      'afternoon'
    elsif hour <= 22
      'evening'
    end
  end
end
