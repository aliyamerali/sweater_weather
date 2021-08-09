require 'rails_helper'

RSpec.describe 'Brewery PORO' do
  it 'has readable attributes' do
    brewery_data = {
        "id": 8962,
        "obdb_id": "black-beak-brewing-denver",
        "name": "Black Beak Brewing",
        "brewery_type": "planning",
        "street": nil,
        "address_2": nil,
        "address_3": nil,
        "city": "Denver",
        "state": "Colorado",
        "county_province": nil,
        "postal_code": "80237-1907",
        "country": "United States",
        "longitude": "-104.984696",
        "latitude": "39.7391428",
        "phone": "3032107836",
        "website_url": nil,
        "updated_at": "2018-08-24T00:00:00.000Z",
        "created_at": "2018-07-24T00:00:00.000Z"
    }
    brewery = Brewery.new(brewery_data)

    expect(brewery.id).to eq(8962)
    expect(brewery.name).to eq("Black Beak Brewing")
    expect(brewery.brewery_type).to eq("planning")
  end
end
