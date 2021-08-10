require 'rails_helper'

RSpec.describe 'Destination Forecast Facade' do
  before :each do
    @user = User.create!({
                      "email": 'whatever@example.com',
                      "password": "password",
                      "password_confirmation": "password"
                    })
    @starting = 'Denver,CO'
    @short_ending = 'Longmont,CO'
    @long_ending = 'Anchorage,Alaska'
    @invalid_destination = 'ser5e4'
    @incalculable_destination = 'Colombia'

    successful_response_short = File.read('spec/fixtures/route_success.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=#{@starting}&to=#{@short_ending}&key=#{ENV['MAPQUEST_API_KEY']}")
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
    stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{@short_ending}")
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

  it 'Returns travel time and weather at ETA - short trip' do
    output = RoadtripFacade.get_roadtrip(@starting, @short_ending)

    expect(output[:roadtrip].origin).to eq(@starting)
    expect(output[:roadtrip].destination).to eq(@short_ending)
    expect(output[:roadtrip].duration).to eq('2 hours, 39 minutes')
    expect(output[:forecast].temperature).to eq(89.62)
    expect(output[:forecast].conditions).to eq('few clouds')
  end

  it 'Returns travel time and weather at ETA - long trip' do
    output = RoadtripFacade.get_roadtrip(@starting, @long_ending)

    expect(output[:roadtrip].origin).to eq(@starting)
    expect(output[:roadtrip].destination).to eq(@long_ending)
    expect(output[:roadtrip].duration).to eq('51 hours, 40 minutes')
    expect(output[:forecast].temperature).to eq(58.15)
    expect(output[:forecast].conditions).to eq('light rain')
  end
end
