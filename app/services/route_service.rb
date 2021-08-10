class RouteService
  def self.get_route(origin, destination)
    response = Rails.cache.fetch "#{origin}+#{destination}_response", expires_in: 12.hours do
      Faraday.get "http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_API_KEY']}&from=#{origin}&to=#{destination}"
    end

    JSON.parse(response.body, symbolize_names: true)
  end
end
