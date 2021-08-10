require 'rails_helper'

RSpec.describe 'Geocode location service' do
  describe 'class methods' do
    describe '.lat_long ' do

      it 'takes in a city,state and returns lat_long response' do
        location = "denver,co"
        lat_long_response = File.read('spec/fixtures/lat_long_successful.json')
        stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{location}").
            to_return(status: 200, body: lat_long_response, headers: {})

        response = GeocodeService.lat_long(location)
        expected = {
                    "lat": 39.738453,
                    "lng": -104.984853
                    }

        expect(response[:info][:statuscode]).to eq(0)
        expect(response[:results].first[:locations].length).to eq(2)
        expect(response[:results].first[:locations].first[:latLng]).to eq(expected)
      end

      it 'returns a 400 if not enough data given' do
        location = ""
        lat_long_response = File.read('spec/fixtures/lat_long_failure.json')
        stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{location}").
            to_return(status: 200, body: lat_long_response, headers: {})

        response = GeocodeService.lat_long(location)

        expect(response[:info][:statuscode]).to eq(400)
        expect(response[:results].first[:locations]).to eq([])
      end

    end
  end
end
