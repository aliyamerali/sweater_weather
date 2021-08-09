class BreweryFacade
  def self.find_breweries(location, quantity)
    lat_long_data = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    lat_long = "#{lat_long_data[:lat]},#{lat_long_data[:lng]}"

    breweries = if quantity.to_i <= 50
                  BreweryService.find_breweries(lat_long, quantity)
                else
                  breweries_from_multiple_pages(lat_long, quantity)
                end

    breweries.map do |brewery|
      Brewery.new(brewery)
    end
  end

  def self.breweries_from_multiple_pages(lat_long, quantity)
    breweries = []
    full_pages = quantity.to_i / 50
    final_page_num = full_pages + 1
    final_page_count = quantity.to_i % 50

    full_pages.times do |index|
      breweries << BreweryService.find_breweries(lat_long, 50, (index + 1))
    end

    breweries << BreweryService.find_breweries(lat_long, 50, final_page_num).take(final_page_count)
    breweries.flatten!
  end
end
