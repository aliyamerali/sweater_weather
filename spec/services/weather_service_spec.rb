require 'rails_helper'

RSpec.describe 'Weather service' do
  describe 'class methods' do
    describe '.forecast ' do

      it 'takes in a lat_long and returns weather data' do
        lat = 39.738453
        long = -104.984853
        response = WeatherService.forecast(lat, long)

        expect(response).to have_key(:current)
        expect(response).to have_key(:daily)
        expect(response).to have_key(:hourly)
        expect(response).to_not have_key(:minutely)
        expect(response).to_not have_key(:alerts)
      end

      it 'returns a 400 if not enough or bad data given' do
        lat = 2536
        long = 260345
        response = WeatherService.forecast(lat, long)

        expect(response[:cod]).to eq('400')

        lat = nil
        long = nil
        response = WeatherService.forecast(lat, long)

        expect(response[:cod]).to eq('400')
      end

    end
  end
end
