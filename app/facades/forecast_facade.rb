class ForecastFacade
  def self.get_forecast(location)
    lat_long = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    lat = lat_long[:lat]
    long = lat_long[:lng]
    weather = WeatherService.forecast(lat, long)
    forecast = Forecast.new(weather)
  end
end
