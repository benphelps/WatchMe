json.array!(@streams) do |stream|
  json.extract! stream, :id, :name, :description, :public_key
  json.url stream_url(stream, format: :json)
end
