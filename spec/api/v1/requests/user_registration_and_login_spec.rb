require 'rails_helper'

RSpec.describe 'User registration and login' do
  describe 'user registration' do
    it 'receives email, password, and password confirmation to create user record'
    it 'does not create record if password and password confirmation do not match'
    it 'does not create record if email is already registered'
    it 'does not create record if any field is missing'
    it 'returns the email and a unique, 27-character api_key'
  end
end
