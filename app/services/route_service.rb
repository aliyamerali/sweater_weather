class RouteService
  def self.get_route(origin, destination)
    response = Faraday.get "http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_API_KEY']}&from=#{origin}to=#{destination}"
    JSON.parse(response.body, symbolize_names: true)
  end
end
