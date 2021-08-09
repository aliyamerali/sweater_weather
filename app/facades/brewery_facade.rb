class BreweryFacade
  def self.find_breweries(location, quantity)
    lat_long_data = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    lat_long = "#{lat_long_data[:lat]},#{lat_long_data[:lng]}"

    breweries_data = BreweryService.find_breweries(lat_long, quantity)

    breweries = breweries_data.map do |brewery|
      Brewery.new(brewery)
    end
  end
end
