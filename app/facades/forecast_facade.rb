class ForecastFacade
  def self.get_forecast(location, units = 'imperial')
    geocode = GeocodeService.lat_long(location)
    if geocode.instance_of?(Error)
      geocode
    else
      lat_long = geocode[:results].first[:locations].first[:latLng]
      lat = lat_long[:lat]
      long = lat_long[:lng]
      weather = WeatherService.forecast(lat, long, units)
      Forecast.new(weather)
    end
  end
end
