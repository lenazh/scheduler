json.array!(@preferences) do |preference|
  json.extract! preference, :id, :preference, :created_at
  json.url course_preference_url(@course.id, preference.id, format: :json)
end