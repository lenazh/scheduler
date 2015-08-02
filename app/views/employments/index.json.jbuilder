json.array!(@employments) do |employment|
  json.extract! employment, :id, :hours_per_week, :created_at, :updated_at
  json.extract! employment.gsi, :name, :email, :signed_in_before
  json.url course_employments_url(@course.id, employment.id)
end
