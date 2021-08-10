class RoadtripSerializer
  def self.get_roadtrip(roadtrip, destination_forecast)
    {
      data: {
        id: nil,
        type: 'roadtrip',
        attributes: {
          start_city: roadtrip.origin,
          end_city: roadtrip.destination,
          travel_time: roadtrip.duration,
          weather_at_eta: if destination_forecast.nil?
                            {}
                          else
                            {
                              temperature: destination_forecast.temperature,
                              conditions: destination_forecast.conditions
                            }
                          end
        }
      }
    }
  end
end
