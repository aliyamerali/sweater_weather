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

        expect(response[:results].length).to eq(10)
        expect(response[:results].first[:urls]).to have_key(:regular)
        expect(response[:results].first[:user]).to have_key(:username)
        expect(response[:results].first[:user][:links]).to have_key(:self)

        # When displaying a photo from Unsplash, your application must attribute Unsplash,
        # the Unsplash photographer, and contain a link back to their Unsplash profile.
        # All links back to Unsplash should use utm parameters in the
        # ?utm_source=your_app_name&utm_medium=referral
      end
    end
  end
end
