require 'rails_helper'

RSpec.describe "Get background image for weather page" do
  before :each do
    query = 'denver,co clear sky afternoon'
    image_search_success = File.read('spec/fixtures/image_search_success.json')
    stub_request(:get, "https://api.unsplash.com/search/photos?query=#{query}&client_id=#{ENV['UNSPLASH_API_KEY']}").
        to_return(status: 200, body: image_search_success, headers: {})

  end
end
