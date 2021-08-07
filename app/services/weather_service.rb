class WeatherService
  def self.forecast(lat, long)
    exclude = "minutely,alerts"
    response = Faraday.get "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&exclude=#{exclude}&appid=#{ENV['WEATHER_API_KEY']}"
    JSON.parse(response.body, symbolize_names: true)
  end
end
