require 'rails_helper'

RSpec.describe "Get background image for weather page" do
  before :each do
    query = 'denver,co clear sky afternoon'
    image_search_success = File.read('spec/fixtures/image_search_success.json')
    stub_request(:get, "https://api.unsplash.com/search/photos?query=#{query}&client_id=#{ENV['UNSPLASH_API_KEY']}").
        to_return(status: 200, body: image_search_success, headers: {})
  end

  it 'returns an image link, source, author, and author link for location, time of day, weather' do
    get '/api/v1/backgrounds?location=denver'

    output = JSON.parse(response.body, symbolize_names: true)
    binding.pry
    expect(response).to be_successful
    expect(output[:data][:type]).to eq("Image")
    expect(output[:data][:id]).to eq(nil)
    expect(output[:data][:attributes]).to have_key(:image_url)
    expect(output[:data][:attributes][:image_url].split('?').last).to eq('utm_source=sweater_weather&utm_medium=referral')
    expect(output[:data][:attributes]).to have_key(:location)
    expect(output[:data][:attributes]).to have_key(:source)
    expect(output[:data][:attributes]).to have_key(:author)
    expect(output[:data][:attributes]).to have_key(:author_profile)
    expect(output[:data][:attributes][:author_profile].split('?').last).to eq('utm_source=sweater_weather&utm_medium=referral')
  end
end
