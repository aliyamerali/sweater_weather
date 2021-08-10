class ForecastFacade
  def self.get_forecast(location)
    geocode = GeocodeService.lat_long(location)
    if geocode.class == Error
      geocode
    else
      lat_long = geocode[:results].first[:locations].first[:latLng]
      lat = lat_long[:lat]
      long = lat_long[:lng]
      weather = WeatherService.forecast(lat, long)
      Forecast.new(weather)
    end
  end
end
