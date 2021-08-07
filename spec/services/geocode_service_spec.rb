require 'rails_helper'

RSpec.describe 'Geocode location service' do
  describe 'class methods' do
    describe '.lat_long ' do

      it 'takes in a city,state and returns lat_long response' do
        location = "denver,co"
        response = GeocodeService.lat_long(location)
        output = JSON.parse(response, symbolize_names: true)
        expected = {
                    "lat": 39.738453,
                    "lng": -104.984853
                    }

        expect(response.status).to be_successful
        expect(output[:results].first[:locations].length).to eq(2)
        expect(output[:results].first[:locations].first[:latLng]).to eq(expected)
      end

      it 'returns a 400 if not enough data given' do
        location = ""
        response = GeocodeService.lat_long(location)
        output = JSON.parse(response, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(output[:results].first[:locations]).to eq([])
      end

    end
  end
end
