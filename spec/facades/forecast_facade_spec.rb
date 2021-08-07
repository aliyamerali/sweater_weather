require 'rails_helper'

RSpec.describe 'Forecast Facade' do
  before :each do
    @location = "denver,co"
    lat_long_response = File.read('spec/fixtures/lat_long_successful.json')
    stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['GEOCODE_API_KEY']}&location=#{@location}").
        to_return(status: 200, body: lat_long_response, headers: {})

    lat = 39.738453
    long = -104.984853
    units="imperial"
    exclude = "minutely,alerts"
    weather_response = File.read('spec/fixtures/weather_successful.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&exclude=#{exclude}&lat=#{lat}&lon=#{long}&units=#{units}")
      .to_return(status: 200, body: weather_response, headers: {})
  end
  
  it '.get_forecast takes in a city and state and returns forecast' do
    location = ("denver,co")
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
