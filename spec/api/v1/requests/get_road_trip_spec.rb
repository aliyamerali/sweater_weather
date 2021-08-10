require 'rails_helper'

RSpec.describe 'Road Trip details endpoint' do
  before :each do
    @user = User.create!({
                      "email": 'whatever@example.com',
                      "password": "password",
                      "password_confirmation": "password"
                    })
    @starting = 'Denver,CO'
    @ending = 'Longmont,CO'
    @long_ending = 'Anchorage,Alaska'
    @invalid_destination = 'ser5e4'
    @incalculable_destination = 'Colombia'

    successful_response_short = File.read('spec/fixtures/route_success.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}&to=#{@ending}&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: successful_response_short, headers: {})

    successful_response_long = File.read('spec/fixtures/route_success_long.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}&to=#{@long_ending}&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: successful_response_long, headers: {})

    failed_response_1 = File.read('spec/fixtures/route_failure.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}&to=&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: failed_response_1, headers: {})

    failed_response_2 = File.read('spec/fixtures/route_failure_2.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}&to=#{@invalid_destination}&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: failed_response_2, headers: {})

    failed_response_3 = File.read('spec/fixtures/route_failure_3.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}&to=#{@incalculable_destination}&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: failed_response_3, headers: {})

    # short trip weather stubs
    lat_long_response = File.read('spec/fixtures/lat_long_destination.json')
    stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{@ending}")
      .to_return(status: 200, body: lat_long_response, headers: {})

    lat = 40.165729
    long = -105.101194
    weather_at_destination = File.read('spec/fixtures/weather_at_destination.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&exclude=minutely,alerts&appid=#{ENV['WEATHER_API_KEY']}&units=imperial")
      .to_return(status: 200, body: weather_at_destination, headers: {})

    # long trip weather stubs
    lat_long_response_long = File.read('spec/fixtures/lat_long_destination_long.json')
    stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{@long_ending}")
      .to_return(status: 200, body: lat_long_response_long, headers: {})

    lat = 61.216583
    long = -149.899597
    weather_at_destination_long = File.read('spec/fixtures/weather_at_destination_long.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&exclude=minutely,alerts&appid=#{ENV['WEATHER_API_KEY']}&units=imperial")
      .to_return(status: 200, body: weather_at_destination_long, headers: {})
  end

  it 'if API key is valid, returns travel time and weather at ETA - short trip' do
    request_body = {
                    origin: @starting,
                    destination: @ending,
                    api_key: @user.api_key
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)

    expect(output[:data][:type]).to eq("roadtrip")
    expect(output[:data][:attributes][:start_city]).to eq(@starting)
    expect(output[:data][:attributes][:end_city]).to eq(@ending)
    expect(output[:data][:attributes][:travel_time]).to eq('2 hours, 39 minutes')
    expect(output[:data][:attributes][:weather_at_eta][:temperature]).to eq(89.62)
    expect(output[:data][:attributes][:weather_at_eta][:conditions]).to eq("few clouds")
  end

  it 'if API key is valid, returns travel time and weather at ETA - long trip' do
    request_body = {
                    origin: @starting,
                    destination: @long_ending,
                    api_key: @user.api_key
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)

    expect(output[:data][:type]).to eq("roadtrip")
    expect(output[:data][:attributes][:start_city]).to eq(@starting)
    expect(output[:data][:attributes][:end_city]).to eq(@long_ending)
    expect(output[:data][:attributes][:travel_time]).to eq('51 hours, 40 minutes')
    expect(output[:data][:attributes][:weather_at_eta][:temperature]).to eq(58.15)
    expect(output[:data][:attributes][:weather_at_eta][:conditions]).to eq("light rain")
  end

  it 'if no route is possible, returns impossible travel time and no weather' do
    request_body = {
                    origin: @starting,
                    destination: @incalculable_destination,
                    api_key: @user.api_key
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)

    expect(output[:data][:type]).to eq("roadtrip")
    expect(output[:data][:attributes][:start_city]).to eq(@starting)
    expect(output[:data][:attributes][:end_city]).to eq(@incalculable_destination)
    expect(output[:data][:attributes][:travel_time]).to eq('impossible')
    expect(output[:data][:attributes][:weather_at_eta]).to eq({})
  end

  it 'if API key is invalid, returns 401 unauthorized' do
    request_body = {
                    origin: @starting,
                    destination: @ending,
                    api_key: '123445676789'
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(401)
    expect(output[:errors].first[:title]).to eq('Invalid Credentials')
  end

  it 'if API key is missing, returns 401 unauthorized' do
    request_body = {
                    origin: @starting,
                    destination: @ending
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(401)
    expect(output[:errors].first[:title]).to eq('Invalid Credentials')
  end

  it 'if origin or destination is missing, returns 400 bad request' do
    request_body = {
                    destination: @ending,
                    api_key: @user.api_key
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(output[:errors].first[:title]).to eq('Invalid Request')
  end
end
