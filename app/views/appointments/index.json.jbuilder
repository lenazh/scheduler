json.array!(@appointments) do |appointment|
  json.extract! appointment.course, :id, :name, :created_at
  json.url course_url(appointment.course, format: :json)
end