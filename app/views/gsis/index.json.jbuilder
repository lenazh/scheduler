json.array!(@gsis) do |gsi|
  json.extract! gsi, :id, :name, :email, :hours_per_week, :signed_in_before, :created_at, :updated_at
  json.url course_gsi_url(@course.id, gsi.id)
end
