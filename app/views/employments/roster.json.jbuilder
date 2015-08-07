json.array!(@employments) do |employment|
  json.extract! employment, :hours_per_week
  json.extract! employment.gsi, :id, :name, :email
end
