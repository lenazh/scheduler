user = current_user
json.extract! @course, :id, :name, :user_id, :created_at, :updated_at
json.is_owned user.owns_course?(@course)
json.is_teaching user.teaching_course?(@course)