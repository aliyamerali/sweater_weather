require 'rails_helper'

RSpec.describe "Get background image for weather page" do
  before :each do
    @location = "denver"
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

    query = 'denver broken clouds afternoon'
    image_search_success = File.read('spec/fixtures/image_search_success.json')
    stub_request(:get, "https://api.unsplash.com/search/photos?query=#{query}&client_id=#{ENV['UNSPLASH_API_KEY']}").
        to_return(status: 200, body: image_search_success, headers: {})
  end

  it 'returns an image link, source, author, and author link for location, time of day, weather' do
    get '/api/v1/backgrounds?location=denver'

    output = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(output[:data][:type]).to eq("image")
    expect(output[:data][:id]).to eq(nil)
    expect(output[:data][:attributes]).to have_key(:image_url)
    expect(output[:data][:attributes][:image_url].split('&')[-2]).to eq('utm_source=sweater_weather')
    expect(output[:data][:attributes][:image_url].split('&')[-1]).to eq('utm_medium=referral')
    expect(output[:data][:attributes]).to have_key(:location)
    expect(output[:data][:attributes]).to have_key(:source)
    expect(output[:data][:attributes]).to have_key(:author)
    expect(output[:data][:attributes]).to have_key(:author_profile)
    expect(output[:data][:attributes][:author_profile].split('?').last).to eq('utm_source=sweater_weather&utm_medium=referral')
  end
end
