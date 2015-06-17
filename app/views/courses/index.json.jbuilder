json.array!(@courses) do |course|
  json.extract! course, :id, :name, :user_id, :created_at
  json.url course_url(course, format: :json)
end
