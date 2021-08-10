class RoadtripFacade
  def self.get_roadtrip(origin, destination)
    duration = secs_to_hrs_mins(RouteService.get_route(origin, destination)[:route][:time])
    roadtrip = Roadtrip.new(origin, destination, duration)

    lat_long = GeocodeService.lat_long(destination)[:results].first[:locations].first[:latLng]
    weather = WeatherService.forecast(lat_long[:lat], lat_long[:lng])
    destination_forecast = DestinationForecast.new(weather, duration)

    { roadtrip: roadtrip, forecast: destination_forecast }
  end

  def self.secs_to_hrs_mins(seconds)
    {
      hours: seconds / (60 * 60),
      minutes: (seconds / 60) % 60
    }
  end
end
