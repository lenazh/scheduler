json.array!(@sections) do |section|
  json.extract! section, :id, :name, :lecture, :start_hour, :start_minute, :duration_hours, :gsi_id, :weekday, :room
  json.url course_section_url(@course.id, section.id)
  preferences = section.preferences.sort { |x, y | y.preference <=> x.preference }
  json.gsis do
    json.array!(preferences) do |preference|
      json.extract! preference.user, :id, :name
      json.extract! preference, :preference
    end
  end
end
