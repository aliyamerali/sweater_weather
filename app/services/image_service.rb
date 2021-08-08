class ImageService
  def self.search(query)
    response = Faraday.get "https://api.unsplash.com/search/photos?client_id=#{ENV['UNSPLASH_API_KEY']}&query=#{query}"
    JSON.parse(response.body, symbolize_names: true)
  end
end
