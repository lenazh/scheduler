json.array!(@sections) do |section|
  json.extract! section, :id, :name, :lecture, :start_hour, :start_minute, :duration_hours, :gsi_id, :weekday, :room
  json.url course_section_url(@course.id, section.id)
end
