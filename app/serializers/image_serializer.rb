class ImageSerializer
  include JSONAPI::Serializer

  set_type :image
  set_id { nil }
  attributes :image_url, :location, :source, :author, :author_profile
end
