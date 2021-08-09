require 'rails_helper'

RSpec.describe 'Breweries Endpoint' do
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

    @quantity = 5
    brewery_response = File.read('spec/fixtures/breweries_denver_5.json')
    lat_long = "#{lat},#{long}"
    stub_request(:get, "https://api.openbrewerydb.org/breweries?by_dist=#{lat_long}&per_page=#{@quantity}")
      .to_return(status: 200, body: brewery_response, headers: {})
  end

  it 'returns forecast and brewery information' do

    get "/api/v1/breweries?location=#{@location}&quantity=#{@quantity}"

    expect(response).to be_successful

    output = JSON.parse(response.body, symbolize_names: true)

    expect(output[:data][:id]).to eq(nil)
    expect(output[:data][:type]).to eq('breweries')
    expect(output[:data][:attributes][:destination]).to eq(@location)

    expect(output[:data][:attributes][:forecast]).to be_a(Hash)
    expect(output[:data][:attributes][:forecast]).to have_key(:summary)
    expect(output[:data][:attributes][:forecast]).to have_key(:temperature)

    expect(output[:data][:attributes][:breweries]).to be_a(Array)
    expect(output[:data][:attributes][:breweries].length).to eq(@quantity)
    expect(output[:data][:attributes][:breweries].first).to have_key(:id)
    expect(output[:data][:attributes][:breweries].first).to have_key(:name)
    expect(output[:data][:attributes][:breweries].first).to have_key(:brewery_type)
  end

  it 'returns the correct amount of breweries'

end
