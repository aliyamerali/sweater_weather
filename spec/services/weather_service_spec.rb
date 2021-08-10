require 'rails_helper'

RSpec.describe 'Weather service' do
  describe 'class methods' do
    describe '.forecast ' do
      it 'takes in a lat_long and returns weather data' do
        lat = 39.738453
        long = -104.984853
        units="imperial"
        exclude = "minutely,alerts"
        weather_response = File.read('spec/fixtures/weather_successful.json')
        stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&exclude=#{exclude}&lat=#{lat}&lon=#{long}&units=#{units}")
          .to_return(status: 200, body: weather_response, headers: {})

        response = WeatherService.forecast(lat, long, units)

        expect(response).to have_key(:current)
        expect(response).to have_key(:daily)
        expect(response).to have_key(:hourly)
        expect(response).to_not have_key(:minutely)
        expect(response).to_not have_key(:alerts)
      end

      it 'returns a 400 if bad data given' do
        lat = 2536
        long = 260345
        units="imperial"
        exclude = "minutely,alerts"
        weather_response = File.read('spec/fixtures/weather_failure.json')
        stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&exclude=#{exclude}&lat=#{lat}&lon=#{long}&units=#{units}")
          .to_return(status: 200, body: weather_response, headers: {})

        response = WeatherService.forecast(lat, long, units)

        expect(response[:cod]).to eq('400')
      end

      it 'returns a 400 if not enough data given' do
        lat = nil
        long = nil
        units="imperial"
        exclude = "minutely,alerts"
        weather_response = File.read('spec/fixtures/weather_failure.json')
        stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&exclude=#{exclude}&lat=#{lat}&lon=#{long}&units=#{units}")
          .to_return(status: 200, body: weather_response, headers: {})
        response = WeatherService.forecast(lat, long, units)

        expect(response[:cod]).to eq('400')
      end

    end
  end
end
