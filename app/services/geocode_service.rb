class GeocodeService
  def self.lat_long(location)
    response = Faraday.get "http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{location}"
    JSON.parse(response.body, symbolize_names: true)
  end
end
