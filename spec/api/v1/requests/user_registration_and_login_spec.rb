require 'rails_helper'

RSpec.describe 'User registration and login' do
  before :each do
    @email = "whatever@example.com"
    @headers = {"CONTENT_TYPE" => "application/json"}
    @body = {
              "email": @email,
              "password": "password",
              "password_confirmation": "password"
            }
  end

  describe 'user registration' do
    it 'receives email, password, and password confirmation to create user record' do
      post '/api/v1/users', params: @body, as: :json

      expect(response).to be_successful
      expect(User.last.email).to eq(@email)
    end

    it 'returns the email and a unique, 27-character api_key' do
      post '/api/v1/users', params: @body, as: :json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(body[:data][:type]).to eq("users")
      expect(body[:data][:id]).to be_a(String)
      expect(body[:data][:attributes].keys.length).to eq(2)
      expect(body[:data][:attributes][:email]).to be_a(String)
      expect(body[:data][:attributes][:api_key]).to be_a(String)
    end

    xit 'will not return an api key that is already in the DB' do
      # how to test this? is the validation test enough? This just catches that the response
      # won't ever get the error that the api_key is not unique
    end

    it 'does not create record if password and password confirmation do not match' do
      mismatch_body = {
                        "email": @email,
                        "password": "password!",
                        "password_confirmation": "password"
                      }
      post '/api/v1/users', params: mismatch_body, as: :json

      expect(response.status).to eq(400)
      message = JSON.parse(response.body, symbolize_names: true)
      expect(message[:response]).to eq({:password_confirmation=>["doesn't match Password"]})
    end

    it 'does not create record if email is already registered' do
      post '/api/v1/users', params: @body, as: :json
      expect(response).to be_successful

      post '/api/v1/users', params: @body, as: :json
      expect(response.status).to eq(400)
      message = JSON.parse(response.body, symbolize_names: true)
      expect(message[:response]).to eq({email: ["has already been taken"]})
    end

    it 'does not create record if any field is missing' do
      incomplete_body = {
                        "email": @email,
                        "password": "",
                        "password_confirmation": "password"
                      }
      post '/api/v1/users', params: incomplete_body, as: :json

      expect(response.status).to eq(400)
      message = JSON.parse(response.body, symbolize_names: true)
      expect(message[:response]).to eq({:password=>["can't be blank"], :password_digest=>["can't be blank"]})
    end
  end
end
