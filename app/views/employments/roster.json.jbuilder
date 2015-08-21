json.array!(@employments) do |employment|
  json.extract! employment, :hours_per_week
  gsi = employment.gsi
  json.extract! gsi, :id, :name, :email
  json.sections_can_teach gsi.preferences_in(@course)
end
