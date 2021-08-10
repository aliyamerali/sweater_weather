class GeocodeService
  def self.lat_long(location)
    response = Rails.cache.fetch "#{location}_response", expires_in: 24.hours do
      Faraday.get "http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{location}"
    end

    if response.body.empty?
      Error.new('Illegal argument from request: Insufficient info for location', 'Bad Request', 400)
    else
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      if parsed_response[:info][:statuscode] == 400
        Error.new('Illegal argument from request: Insufficient info for location', 'Bad Request', 400)
      else
        parsed_response
      end
    end
  end
end
