class BreweryService
  def self.find_breweries(lat_long, quantity)
    response = Faraday.get "https://api.openbrewerydb.org/breweries?by_dist=#{lat_long}&per_page=#{quantity}"
    JSON.parse(response.body, symbolize_names: true)
  end
end
