json.array!(@albums) do |album|
  json.extract! album, :id, :name, :private, :caption
  json.url album_url(album, format: :json)
end
