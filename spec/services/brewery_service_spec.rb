require 'rails_helper'

RSpec.describe 'Brewery Service' do
  describe 'class methods' do
    describe '.find_breweries' do
      it 'returns requested count of breweries by distance from the given lat/long' do
        lat_long = '39.738453,-104.984853'
        quantity = 5

        brewery_response = File.read('spec/fixtures/breweries_denver_5.json')
        stub_request(:get, "https://api.openbrewerydb.org/breweries?by_dist=#{lat_long}&per_page=#{@quantity}")
          .to_return(status: 200, body: brewery_response, headers: {})

        response = BreweryService.find_breweries(lat_long, quantity)

        expect(response).to be_a(Array)
        expect(response.length).to eq(quantity)
        expect(response.first).to have_key(:id)
        expect(response.first).to have_key(:name)
        expect(response.first).to have_key(:brewery_type)
      end

      # it 'returns an empty response and 500 stat\us if inaccurate/no lat/long given' do
      #
      # end
    end
  end
end
