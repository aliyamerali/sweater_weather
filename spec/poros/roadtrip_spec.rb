require 'rails_helper'

RSpec.describe 'Roadtrip PORO' do
  it 'has readable attributes' do
    duration = { hours: 26, minutes: 27 }
    roadtrip = Roadtrip.new('Denver', 'New York', duration)

    expect(roadtrip.origin).to eq('Denver')
    expect(roadtrip.destination).to eq('New York')
    expect(roadtrip.duration).to eq('26 hours, 27 minutes')
  end
end
