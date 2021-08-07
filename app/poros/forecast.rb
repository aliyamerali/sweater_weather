class Forecast
  attr_reader :current_weather, :hourly_weather, :daily_weather

  def initialize(data)
    @current_weather = get_current_weather(data[:current])
    @hourly_weather = get_hourly_weather(data[:hourly])
    @daily_weather = get_daily_weather(data[:daily])
  end

  def get_current_weather(data)
    {
      datetime: data[:dt], #CONVERT TO READABLE DATETIME
      sunrise: data[:sunrise], #CONVERT TO READABLE 1628337889
      sunset: data[:sunset], #CONVERT TO READABLE 1628388393
      sunset: data[:sunset],
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
    hourly_data.take(8).map do |hour_data|
      {
        time: hour_data[:dt], #CONVERT TO READABLE TIME ONLY
        temperature: hour_data[:temp],
        conditions: hour_data[:weather].first[:description],
        icon: hour_data[:weather].first[:icon]
      }
    end
  end

  def get_daily_weather(daily_data)
    daily_data.take(5).map do |day_data|
      {
        date: day_data[:dt], #CONVERT TO READABLE DATE ONLY
        sunrise: day_data[:sunrise], #CONVERT TO READABLE 1628352000
        sunset: day_data[:sunset], #CONVERT TO READABLE 1628352000
        max_temp: day_data[:temp][:max],
        min_temp: day_data[:temp][:min],
        conditions: day_data[:weather].first[:description],
        icon: day_data[:weather].first[:icon]
      }
    end
  end
end
