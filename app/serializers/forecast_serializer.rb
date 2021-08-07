class ForecastSerializer
  include JSONAPI::Serializer

  set_type :forecast
  set_id { nil }
  attributes :current_weather, :daily_weather, :hourly_weather
end
