RSpec.describe 'Forecast PORO' do
  before :each do
    sample_data = File.read('spec/fixtures/image_search_success.json')
    data = JSON.parse(sample_data, symbolize_names: true)
    image_data = data[:results].first
    @image = Image.new(image_data)
  end

  it 'has only the requested readable attributes' do
    expect(@image.image_url.split('?').first).to eq("https://images.unsplash.com/photo-1619109663062-c011afb8fb13")
    expect(@image.image_url.split('?').last).to eq('utm_source=sweater_weather&utm_medium=referral')
    expect(@image.location).to eq('denver')
    expect(@image.source).to eq('Unsplash')
    expect(@image.author).to eq('Andrew Coop')
    expect(@image.author_profile.split('?').first).to eq("https://api.unsplash.com/photos/2spjXRLxPUQ")
    expect(@image.author_profile.split('?').last).to eq('utm_source=sweater_weather&utm_medium=referral')
  end
end
