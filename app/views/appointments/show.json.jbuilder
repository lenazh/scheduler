user = current_user
course = @appointment.course

json.extract! course, :id, :name, :created_at
json.is_owned user.owns_course?(course)
json.is_teaching user.teaching_course?(course)