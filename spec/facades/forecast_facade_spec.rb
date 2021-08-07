require 'rails_helper'

RSpec.describe 'Forecast Facade' do
  it '.get_forecast takes in a city and state and returns forecast' do
    forecast = ForecastFacade.get_forecast(location)

    expect(forecast.current_weather.keys.include?(:datetime)).to eq(true)
    expect(forecast.current_weather.keys.include?(:feels_like)).to eq(true)
    expect(forecast.current_weather.keys.include?(:icon)).to eq(true)
    expect(forecast.daily_weather.count).to eq(5)
    expect(forecast.daily_weather.first.keys.include?(:date)).to eq(true)
    expect(forecast.daily_weather.first.keys.include?(:min_temp)).to eq(true)
    expect(forecast.daily_weather.first.keys.include?(:icon)).to eq(true)
    expect(forecast.hourly_weather.count).to eq(8)
    expect(forecast.hourly_weather.first.keys.include?(:time)).to eq(true)
    expect(forecast.hourly_weather.first.keys.include?(:conditions)).to eq(true)
    expect(forecast.hourly_weather.first.keys.include?(:icon)).to eq(true)

    expect(forecast.current_weather.keys.include?(:pressure)).to eq(false)
    expect(forecast.current_weather.keys.include?(:dew_point)).to eq(false)
    expect(forecast.current_weather.keys.include?(:wind_speed)).to eq(false)
    expect(forecast.daily_weather.first.keys.include?(:moonrise)).to eq(false)
    expect(forecast.daily_weather.first.keys.include?(:moon_phase)).to eq(false)
    expect(forecast.daily_weather.first.keys.include?(:wind_speed)).to eq(false)
    expect(forecast.hourly_weather.first.keys.include?(:pressure)).to eq(false)
    expect(forecast.hourly_weather.first.keys.include?(:humidity)).to eq(false)
    expect(forecast.hourly_weather.first.keys.include?(:weather)).to eq(false)
  end
end
