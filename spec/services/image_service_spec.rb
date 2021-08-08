require 'rails_helper'

RSpec.describe 'Image API calls' do
  describe 'class methods' do
    describe '.search' do
      it 'returns 10 image options based on search keywords' do
        query = 'denver,co clear sky afternoon'
        image_search_success = File.read('spec/fixtures/image_search_success.json')
        stub_request(:get, "https://api.unsplash.com/search/photos?client_id=#{ENV['UNSPLASH_API_KEY']}&query=denver,co%20clear%20sky%20afternoon")
          .to_return(status: 200, body: image_search_success, headers: {})

        response = ImageService.search(query)

        expect(response[:results].length).to eq(10)
        expect(response[:results].first[:urls]).to have_key(:regular)
        expect(response[:results].first[:user]).to have_key(:username)
        expect(response[:results].first[:user][:links]).to have_key(:self)
      end

      it 'returns empty response if no search entered' do
        query = ''
        image_search_fail = File.read('spec/fixtures/image_search_fail.json')
        stub_request(:get, "https://api.unsplash.com/search/photos?client_id=#{ENV['UNSPLASH_API_KEY']}&query=#{query}")
          .to_return(status: 200, body: image_search_fail, headers: {})

        response = ImageService.search(query)

        expect(response[:results].length).to eq(0)
      end
    end
  end
end
