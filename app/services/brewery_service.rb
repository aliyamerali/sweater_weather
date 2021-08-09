class BreweryService
  def self.find_breweries(lat_long, quantity, page = 1)
    response = Faraday.get "https://api.openbrewerydb.org/breweries?by_dist=#{lat_long}&per_page=#{quantity}&page=#{page}"
    if response.body == ''
      'Invalid Search Parameters'
    else
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
