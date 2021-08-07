require 'rails_helper'

RSpec.describe 'Weather service' do
  describe 'class methods' do
    describe '.forecast ' do

      it 'takes in a lat_long and returns weather data' do
        lat = 39.738453
        long = -104.984853
        response = WeatherServices.forecast(lat, long)

        expect(response).to have_key(:current)
        expect(response).to have_key(:daily)
        expect(response).to have_key(:hourly)
        expect(response).to_not have_key(:minutely)
        expect(response).to_not have_key(:alerts)
      end

      it 'returns a 400 if not enough data given' do
        lat = 2536
        long = 260345
        response = WeatherServices.forecast(lat, long)

        # expect(response[:info][:statuscode]).to eq(400)
        # expect(response[:results].first[:locations]).to eq([])
      end

    end
  end
end
