class RoadtripFacade
  def self.get_roadtrip(origin, destination, units = 'imperial')
    route_details = RouteService.get_route(origin, destination)

    if !route_possible?(route_details)
      duration = 'impossible'
      destination_forecast = nil
    else
      duration = secs_to_hrs_mins(route_details[:route][:time])
      destination_forecast = destination_forecast_at_eta(destination, duration, units)
    end

    roadtrip = Roadtrip.new(origin, destination, duration)
    { roadtrip: roadtrip, forecast: destination_forecast }
  end

  private_class_method def self.secs_to_hrs_mins(seconds)
    { hours: seconds / (60 * 60),
      minutes: (seconds / 60) % 60 }
  end

  private_class_method def self.route_possible?(route_details)
    impossible_route_messages = ['We are unable to route with the given locations.', 'Unable to calculate route.']
    !impossible_route_messages.include?(route_details[:info][:messages].first)
  end

  private_class_method def self.destination_forecast_at_eta(destination, duration, units)
    lat_long = GeocodeService.lat_long(destination)[:results].first[:locations].first[:latLng]
    weather = WeatherService.forecast(lat_long[:lat], lat_long[:lng], units)
    DestinationForecast.new(weather, duration)
  end
end
