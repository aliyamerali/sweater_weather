class DestinationForecast
  attr_reader :temperature, :conditions

  def initialize(weather, duration)
    @temperature = temp_at_arrival_time(weather, duration)
    @conditions = conditions_at_arrival_time(weather, duration)
  end

  def temp_at_arrival_time(weather, duration)
    if duration[:hours] > 48
      weather[:daily][(duration[:hours] / 24)][:temp][:day]
    else
      weather[:hourly][duration[:hours]][:temp]
    end
  end

  def conditions_at_arrival_time(weather, duration)
    if duration[:hours] > 48
      weather[:daily][(duration[:hours] / 24)][:weather].first[:description]
    else
      weather[:hourly][duration[:hours]][:weather].first[:description]
    end
  end
end
