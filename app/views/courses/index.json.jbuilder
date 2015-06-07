json.array!(@courses) do |course|
  json.extract! course, :id, :name, :user_id
  json.url course_url(course, format: :json)
end
