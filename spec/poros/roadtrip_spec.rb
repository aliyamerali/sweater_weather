require 'rails_helper'

RSpec.describe 'Roadtrip PORO' do
  it 'has readable attributes' do
    roadtrip = Roadtrip.new({
                              origin: 'Denver',
                              destination: 'New York',
                              duration: { hours: 26, minutes: 27 }
                              })

    expect(roadtrip.origin).to eq('Denver')
    expect(roadtrip.origin).to eq('New York')
    expect(roadtrip.duration).to eq('26 hours, 27 minutes')
  end
end
