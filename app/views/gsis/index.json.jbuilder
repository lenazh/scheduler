json.array!(@gsis) do |gsi|
  json.extract! gsi, :id, :name, :email, :created_at, :updated_at
  json.url gsi_url(gsi, format: :json)
end
