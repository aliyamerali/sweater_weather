require 'rails_helper'

RSpec.describe 'Breweries Endpoint' do
  it 'returns forecast and brewery information' do
    location = 'denver,co'
    quantity = 5
    get "/api/v1/breweries?location=#{location}&quantity=#{quantity}"

    expect(response).to be_successful

    output = JSON.parse(response.body, symbolize_names: true)

    expect(output[:data][:id]).to eq('null')
    expect(output[:data][:type]).to eq('breweries')
    expect(output[:data][:attributes][:destination]).to eq(location)

    expect(output[:data][:attributes][:forecast]).to be_a(Hash)
    expect(output[:data][:attributes][:forecast]).to have_key(:summary)
    expect(output[:data][:attributes][:forecast]).to have_key(:temperature)

    expect(output[:data][:attributes][:breweries]).to be_a(Array)
    expect(output[:data][:attributes][:breweries].length).to eq(quantity)
    expect(output[:data][:attributes][:breweries].first).to have_key(:id)
    expect(output[:data][:attributes][:breweries].first).to have_key(:name)
    expect(output[:data][:attributes][:breweries].first).to have_key(:brewery_type)
  end

  it 'returns the correct amount of breweries'

end
