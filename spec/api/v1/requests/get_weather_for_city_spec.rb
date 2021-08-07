require 'rails_helper'

RSpec.describe 'Weather endpoint returns forecast for a given city' do
  it 'takes in a city and state and returns forecast' do
    get '/api/v1/forecast?location=denver,co'

    output = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(output[:id]).to eq(nil)
    expect(output[:type]).to eq('forecast')
    expect(output[:attributes].keys).to eq([:current_weather, :daily_weather, :hourly_weather])
    expect(output[:attributes][:current_weather].keys.include?(:datetime)).to eq(true)
    expect(output[:attributes][:current_weather].keys.include?(:feels_like)).to eq(true)
    expect(output[:attributes][:current_weather].keys.include?(:icon)).to eq(true)
    expect(output[:attributes][:daily_weather].count).to eq(5)
    expect(output[:attributes][:daily_weather].first.keys.include?(:date)).to eq(true)
    expect(output[:attributes][:daily_weather].first.keys.include?(:min_temp)).to eq(true)
    expect(output[:attributes][:daily_weather].first.keys.include?(:icon)).to eq(true)
    expect(output[:attributes][:hourly_weather].count).to eq(8)
    expect(output[:attributes][:hourly_weather].first.keys.include?(:time)).to eq(true)
    expect(output[:attributes][:hourly_weather].first.keys.include?(:conditions)).to eq(true)
    expect(output[:attributes][:hourly_weather].first.keys.include?(:icon)).to eq(true)


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

end
