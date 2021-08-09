require 'rails_helper'

RSpec.describe 'Brewery Facade' do
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

  it '.find_breweries takes in a city,state,quantity and returns forecast and breweries' do
    breweries = BreweryFacade.find_breweries(@location, @quantity)

    expect(breweries.length).to eq(@quantity)
    expect(breweries.first.id).to be_a(Integer)
    expect(breweries.first.name).to be_a(String)
    expect(breweries.first.brewery_type).to be_a(String)
  end
end
