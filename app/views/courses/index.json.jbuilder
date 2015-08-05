user = current_user

json.array!(@courses) do |course|
  json.extract! course, :id, :name, :user_id, :created_at
  json.is_owned user.owns_course?(course)
  json.is_teaching user.teaching_course?(course)
  json.url course_url(course, format: :json)
end
