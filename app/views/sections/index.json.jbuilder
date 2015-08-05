json.array!(@sections) do |section|
  json.extract! section, :id, :name, :lecture, :start_hour, :start_minute, :duration_hours, :weekday, :room
  if section.gsi
    json.gsi do
      json.extract! section.gsi, :id, :name, :email
    end
  end
  preferences = section.preferences.sort { |x, y| y.preference <=> x.preference }
  json.available_gsis do
    json.array!(preferences) do |preference|
      gsi = preference.user
      json.extract! gsi, :id, :name
      json.extract! preference, :preference
      json.hours_per_week gsi.hours(@course) 
    end
  end
  json.url course_section_url(@course.id, section.id)
end
