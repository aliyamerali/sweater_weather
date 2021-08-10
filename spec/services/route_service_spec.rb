require 'rails_helper'

RSpec.describe 'Route API Service' do
  before :each do
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

  describe '.get_route' do
    it 'returns route data from a start/end point' do
      response = RouteService.get_route(@starting, @ending)

      expect(response[:route][:time]).to eq(9556)
      expect(response[:info][:messages].length).to eq(0)
    end

    it 'returns an error if one or more location is missing' do
      response = RouteService.get_route(@starting, "")

      expect(response[:info][:messages].first).to eq("At least two locations must be provided.")
    end

    it 'returns an error if one or more location is invalid' do
      response = RouteService.get_route(@starting, @invalid_destination)

      expect(response[:info][:messages].first).to eq("We are unable to route with the given locations.")
    end

    it 'returns an error message if there is no driving route between locations' do
      response = RouteService.get_route(@starting, @incalculable_destination)

      expect(response[:info][:messages].first).to eq("Unable to calculate route.")
    end
  end
end
