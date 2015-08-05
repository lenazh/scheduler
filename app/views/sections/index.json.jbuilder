json.array!(@sections) do |section|
  json.extract! section, :id, :name, :lecture, :start_hour, :start_minute, :duration_hours, :gsi_id, :weekday, :room
  json.url course_section_url(@course.id, section.id)
  preferences = section.preferences.sort { |x, y | y.preference <=> x.preference }
  json.gsis do
    json.array!(preferences) do |preference|
      gsi = preference.user
      json.extract! gsi, :id, :name
      json.extract! preference, :preference
      json.hours_per_week gsi.hours(@course) 
    end
  end
end
