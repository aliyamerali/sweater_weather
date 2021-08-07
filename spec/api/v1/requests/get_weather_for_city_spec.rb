require 'rails_helper'

RSpec.describe 'Weather endpoint returns forecast for a given city' do
  it 'takes in a city and state and returns forecast' do
    get '/api/v1/forecast?location=denver,co'

    output = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(output[:id]).to eq(nil)
    expect(output[:type]).to eq('forecast')
    expect(output[:attributes].keys).to eq([:current_weather, :daily_weather, :hourly_weather])
    # add test for what fields should NOT be present
  end

end
