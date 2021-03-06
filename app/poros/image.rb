class Image
  attr_reader :image_url, :location, :source, :author, :author_profile

  def initialize(data, location)
    @image_url = url_append(data[:urls][:regular])
    @location = location
    @source = 'Unsplash'
    @author = data[:user][:name]
    @author_profile = url_append(data[:user][:links][:html])
  end

  def url_append(url)
    if url.split('?').length > 1
      "#{url}&utm_source=sweater_weather&utm_medium=referral"
    else
      "#{url}?utm_source=sweater_weather&utm_medium=referral"
    end
  end
end
