require 'rails_helper'

RSpec.describe 'Image API calls' do
  describe 'class methods' do
    describe '.search' do
      it 'returns 10 image options based on search keywords' do
        query = 'denver,co clear sky afternoon'
        image_search_success = File.read('spec/fixtures/image_search_success.json')
        stub_request(:get, "https://api.unsplash.com/search/photos?query=#{query}&client_id=#{ENV['UNSPLASH_API_KEY']}").
            to_return(status: 200, body: image_search_success, headers: {})

        response = ImageService.search("denver,co clear sky afternoon")
        binding.pry
      end
    end
  end
end
