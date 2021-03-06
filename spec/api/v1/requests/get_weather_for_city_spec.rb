require 'rails_helper'

RSpec.describe 'Weather endpoint returns forecast for a given city' do
  before :each do
    @location = "denver,co"
    lat_long_response = File.read('spec/fixtures/lat_long_successful.json')
    stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{@location}").
        to_return(status: 200, body: lat_long_response, headers: {})

    lat = 39.738453
    long = -104.984853
    default_units="imperial"
    alternate_units="metric"
    exclude = "minutely,alerts"
    weather_response_f = File.read('spec/fixtures/weather_successful.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&exclude=#{exclude}&lat=#{lat}&lon=#{long}&units=#{default_units}")
      .to_return(status: 200, body: weather_response_f, headers: {})

    weather_response_c = File.read('spec/fixtures/weather_successful_metric.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&exclude=#{exclude}&lat=#{lat}&lon=#{long}&units=#{alternate_units}")
      .to_return(status: 200, body: weather_response_c, headers: {})
  end

  it 'takes in a city and state and returns forecast' do
    get "/api/v1/forecast?location=#{@location}"

    output = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(output[:id]).to eq(nil)
    expect(output[:type]).to eq('forecast')
    expect(output[:attributes].keys).to eq([:current_weather, :daily_weather, :hourly_weather])

    expect(output[:attributes][:current_weather][:datetime]).to be_a(String)
    expect(output[:attributes][:current_weather][:sunrise]).to be_a(String)
    expect(output[:attributes][:current_weather][:sunset]).to be_a(String)
    expect(output[:attributes][:current_weather][:temperature]).to be_a(Float)
    expect(output[:attributes][:current_weather][:feels_like]).to be_a(Float)
    expect(output[:attributes][:current_weather][:humidity]).to be_a(Integer)
    expect(output[:attributes][:current_weather][:uvi]).to be_a(Float)
    expect(output[:attributes][:current_weather][:visibility]).to be_a(Integer)
    expect(output[:attributes][:current_weather][:conditions]).to be_a(String)
    expect(output[:attributes][:current_weather][:icon]).to be_a(String)

    expect(output[:attributes][:daily_weather].count).to eq(5)
    expect(output[:attributes][:daily_weather].first[:date]).to be_a(String)
    expect(output[:attributes][:daily_weather].first[:sunrise]).to be_a(String)
    expect(output[:attributes][:daily_weather].first[:sunset]).to be_a(String)
    expect(output[:attributes][:daily_weather].first[:max_temp]).to be_a(Float)
    expect(output[:attributes][:daily_weather].first[:min_temp]).to be_a(Float)
    expect(output[:attributes][:daily_weather].first[:conditions]).to be_a(String)
    expect(output[:attributes][:daily_weather].first[:icon]).to be_a(String)


    expect(output[:attributes][:hourly_weather].count).to eq(8)
    expect(output[:attributes][:hourly_weather].first[:time]).to be_a(String)
    expect(output[:attributes][:hourly_weather].first[:temperature]).to be_a(Float)
    expect(output[:attributes][:hourly_weather].first[:conditions]).to be_a(String)
    expect(output[:attributes][:hourly_weather].first[:icon]).to be_a(String)


    expect(output[:attributes].keys.include?(:minutely_weather)).to eq(false)
    expect(output[:attributes].keys.include?(:alerts)).to eq(false)
    expect(output[:attributes][:current_weather].keys.include?(:pressure)).to eq(false)
    expect(output[:attributes][:current_weather].keys.include?(:dew_point)).to eq(false)
    expect(output[:attributes][:current_weather].keys.include?(:wind_speed)).to eq(false)
    expect(output[:attributes][:daily_weather].first.keys.include?(:moonrise)).to eq(false)
    expect(output[:attributes][:daily_weather].first.keys.include?(:moon_phase)).to eq(false)
    expect(output[:attributes][:daily_weather].first.keys.include?(:wind_speed)).to eq(false)
    expect(output[:attributes][:hourly_weather].first.keys.include?(:pressure)).to eq(false)
    expect(output[:attributes][:hourly_weather].first.keys.include?(:humidity)).to eq(false)
    expect(output[:attributes][:hourly_weather].first.keys.include?(:weather)).to eq(false)
  end

  it 'returns an error if invalid city input' do
    empty_location = ""
    lat_long_response = File.read('spec/fixtures/lat_long_failure.json')
    stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{empty_location}").
        to_return(status: 200, body: lat_long_response, headers: {})

    get "/api/v1/forecast?location=#{empty_location}"
    output = JSON.parse(response.body, symbolize_names: true)

    expect(output[:errors].first[:code]).to eq(400)
    expect(output[:errors].first[:status]).to eq('Bad Request')
    expect(output[:errors].first[:message]).to eq('Illegal argument from request: Insufficient info for location')
  end

  it 'can take a unit parameter to return imperial or metric temperature' do
    get "/api/v1/forecast?location=#{@location}&units=metric"

    output = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(output[:id]).to eq(nil)
    expect(output[:type]).to eq('forecast')
    expect(output[:attributes].keys).to eq([:current_weather, :daily_weather, :hourly_weather])

    expect(output[:attributes][:current_weather][:temperature]).to eq(33.96)

    expect(output[:attributes][:daily_weather].first[:max_temp]).to eq(36.06)
    expect(output[:attributes][:daily_weather].first[:min_temp]).to eq(22.27)

    expect(output[:attributes][:hourly_weather].first[:temperature]).to eq(33.96)

    expect(output[:attributes].keys.include?(:minutely_weather)).to eq(false)
    expect(output[:attributes].keys.include?(:alerts)).to eq(false)
  end
end
