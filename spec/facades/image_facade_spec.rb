require 'rails_helper'

RSpec.describe 'Image facade' do
  before :each do
    @location = "denver"
    lat_long_response = File.read('spec/fixtures/lat_long_successful.json')
    stub_request(:get,"http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['GEOCODE_API_KEY']}&location=#{@location}").
        to_return(status: 200, body: lat_long_response, headers: {})

    lat = 39.738453
    long = -104.984853
    units="imperial"
    exclude = "minutely,alerts"
    weather_response = File.read('spec/fixtures/weather_successful.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['WEATHER_API_KEY']}&exclude=#{exclude}&lat=#{lat}&lon=#{long}&units=#{units}")
      .to_return(status: 200, body: weather_response, headers: {})

    query = 'denver broken clouds afternoon'
    image_search_success = File.read('spec/fixtures/image_search_success.json')
    stub_request(:get, "https://api.unsplash.com/search/photos?query=#{query}&client_id=#{ENV['UNSPLASH_API_KEY']}").
        to_return(status: 200, body: image_search_success, headers: {})

    allow(Time).to receive(:now) do
      DateTime.new(2021,8,7,15,5,6)
    end
  end

  describe 'class methods' do
    it '.get image returns an image link, source, author, and author link for location, time of day, weather' do
      image = ImageFacade.get_image(@location)

      expect(image.image_url).to be_a(String)
      expect(image.image_url.split('&')[-2]).to eq('utm_source=sweater_weather')
      expect(image.image_url.split('&')[-1]).to eq('utm_medium=referral')
      expect(image.location).to eq(@location)
      expect(image.source).to eq("Unsplash")
      expect(image.author).to be_a(String)
      expect(image.author_profile).to be_a(String)
      expect(image.author_profile.split('?').last).to eq('utm_source=sweater_weather&utm_medium=referral')
    end

    it '.time_of_day returns string of time of day based on hour' do
      expect(ImageFacade.time_of_day(1)).to eq('night')
      expect(ImageFacade.time_of_day(10)).to eq('morning')
      expect(ImageFacade.time_of_day(15)).to eq('afternoon')
      expect(ImageFacade.time_of_day(21)).to eq('evening')
      expect(ImageFacade.time_of_day(23)).to eq('night')
    end
  end


end
