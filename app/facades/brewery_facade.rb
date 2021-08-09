class BreweryFacade
  def self.find_breweries(location, quantity)
    lat_long_data = GeocodeService.lat_long(location)[:results].first[:locations].first[:latLng]
    lat_long = "#{lat_long_data[:lat]},#{lat_long_data[:lng]}"

    if quantity.to_i <= 50
      breweries = BreweryService.find_breweries(lat_long, quantity)
    else
      breweries = []
      full_pages = quantity.to_i / 50
      full_pages.times.with_index do |index|
        breweries << BreweryService.find_breweries(lat_long, 50, page=(index+1))
      end

      final_page_num = quantity.to_i / 50 + 1
      final_page_count = quantity.to_i % 50
      breweries << BreweryService.find_breweries(lat_long, 50, page=(final_page_num)).take(final_page_count)
      breweries.flatten!
    end

    breweries.map do |brewery|
      Brewery.new(brewery)
    end
  end
end
