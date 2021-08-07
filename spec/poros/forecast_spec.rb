require 'rails_helper'

RSpec.describe 'Forecast PORO' do
  before :each do
    sample_data = File.read('spec/fixtures/weather_successful.json')
    data = JSON.parse(sample_data, symbolize_names: true)

    @forecast = Forecast.new(data)
  end

  it 'has only the requested readable attributes' do
    expect(@forecast.current_weather).to have_key(:uvi)
    expect(@forecast.current_weather).to_not have_key(:pressure)

    expect(@forecast.hourly_weather.count).to eq(8)
    expect(@forecast.hourly_weather.first).to have_key(:time)
    expect(@forecast.hourly_weather.first).to_not have_key(:pressure)

    expect(@forecast.daily_weather.count).to eq(5)
    expect(@forecast.daily_weather.first).to have_key(:date)
    expect(@forecast.daily_weather.first).to_not have_key(:pressure)
  end

  describe 'instance methods' do
    it '#get_current_weather converts UTC timestamps to readable datetime' do
      expect(@forecast.current_weather[:datetime]).to eq("2021-08-07 11:49:39 -06:00")
    end

    it '#get_hourly_weather converts UTC timestamps to readable time' do
      expect(@forecast.hourly_weather.first[:time]).to eq("12:00:00")
    end

    it '#get_daily_weather converts UTC timestamps to readable date' do
      expect(@forecast.daily_weather.first[:date]).to eq("2021-08-08")
    end

  end
end
