class Forecast
  attr_reader :current_weather, :hourly_weather, :daily_weather

  def initialize(data)
    @current_weather = get_current_weather(data[:current])
    @hourly_weather = get_hourly_weather(data[:hourly])
    @daily_weather = get_daily_weather(data[:daily])
  end

  def get_current_weather(data)
    {
      datetime: Time.at(data[:dt]),
      sunrise: Time.at(data[:sunrise]),
      sunset: Time.at(data[:sunset]),
      temperature: data[:temp],
      feels_like: data[:feels_like],
      humidity: data[:humidity],
      uvi: data[:uvi],
      visibility: data[:visibility],
      conditions: data[:weather].first[:description],
      icon: data[:weather].first[:icon]
    }

  end

  def get_hourly_weather(hourly_data)
    hourly_data.drop(1).take(8).map do |hour_data|
      {
        time: Time.at(hour_data[:dt]).strftime("%I:%M:%S"),
        temperature: hour_data[:temp],
        conditions: hour_data[:weather].first[:description],
        icon: hour_data[:weather].first[:icon]
      }
    end
  end

  def get_daily_weather(daily_data)
    daily_data.drop(1).take(5).map do |day_data|
      {
        date: Time.at(day_data[:dt]).strftime("%Y-%m-%d"),
        sunrise: Time.at(day_data[:sunrise]),
        sunset: Time.at(day_data[:sunset]),
        max_temp: day_data[:temp][:max],
        min_temp: day_data[:temp][:min],
        conditions: day_data[:weather].first[:description],
        icon: day_data[:weather].first[:icon]
      }
    end
  end
end
