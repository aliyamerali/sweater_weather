class WeatherService
  def self.forecast(lat, long, units="imperial")
    exclude = "minutely,alerts"
    response = Faraday.get "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&exclude=#{exclude}&appid=#{ENV['WEATHER_API_KEY']}&units=#{units}"
    JSON.parse(response.body, symbolize_names: true)
  end
end
