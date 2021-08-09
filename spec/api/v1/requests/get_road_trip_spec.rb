require 'rails_helper'

RSpec.describe 'Road Trip details endpoint' do
  before :each do
    @user = User.create!({
                      "email": 'whatever@example.com',
                      "password": "password",
                      "password_confirmation": "password"
                    })
    @starting = '1109 N Ogden St, Denver, CO 80218'
    @ending = '6562 Lookout Rd, Boulder, CO 80301'
    @invalid_destination = 'ser5e4'
    @incalculable_destination = 'Colombia'

    successful_response = File.read('spec/fixtures/route_success.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}to=#{@ending}&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: successful_response, headers: {})

    failed_response_1 = File.read('spec/fixtures/route_failure.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}to=&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: failed_response_1, headers: {})

    failed_response_2 = File.read('spec/fixtures/route_failure_2.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}to=#{@invalid_destination}&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: failed_response_2, headers: {})

    failed_response_3 = File.read('spec/fixtures/route_failure_3.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}to=#{@incalculable_destination}&key=#{ENV['MAPQUEST_API_KEY']}")
      .to_return(status: 200, body: failed_response_3, headers: {})
  end

  it 'if API key is valid, returns travel time and weather at ETA' do
    request_body = {
                    'origin': @starting,
                    'destination': @ending,
                    'api_key': @user.api_key
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)

    expect(output[:data][:type]).to eq("roadtrip")
    expect(output[:data][:attributes][:start_city]).to eq(@starting)
    expect(output[:data][:attributes][:end_city]).to eq(@ending)
    expect(output[:data][:attributes][:travel_time]).to eq('0 hours, 39 minutes')
    expect(output[:data][:attributes][:weather_at_eta][:temperature]).to eq(92.82)
    expect(output[:data][:attributes][:weather_at_eta][:conditions]).to eq("few clouds")
  end

  it 'if API key is invalid, returns 401 unauthorized' do
    request_body = {
                    'origin': @starting,
                    'destination': @ending,
                    'api_key': '123445676789'
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)
    expect(output[:errors].first[:title]).to eq('Invalid Credentials')
  end

  it 'if API key is missing, returns 401 unauthorized' do
    request_body = {
                    'origin': @starting,
                    'destination': @ending
                    }
    post '/api/v1/road_trip', params: request_body, as: :json

    output = JSON.parse(response.body, symbolize_names: true)
    expect(output[:errors].first[:title]).to eq('Invalid Credentials')
  end

  it 'if no route is possible, returns impossible travel time and no weather'
  it 'if origin or destination is missing, returns 400 bad request'
  it 'if origin or destination is invalid, returns 400 bad request'
end
