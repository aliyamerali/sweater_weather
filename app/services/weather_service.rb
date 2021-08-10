class WeatherService
  @valid_units = %w[imperial metric]

  def self.forecast(lat, long, units_input)
    units = if @valid_units.include?(units_input)
              units_input
            else
              'imperial'
            end
    exclude = 'minutely,alerts'
    response = Faraday.get "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&exclude=#{exclude}&appid=#{ENV['WEATHER_API_KEY']}&units=#{units}"
    JSON.parse(response.body, symbolize_names: true)
  end
end
