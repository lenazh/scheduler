json.array!(@sections) do |section|
  json.extract! section, :id, :name, :lecture, :start_hour, :start_minute, :duration_hours, :gsi_id, :weekday, :room
  json.url section_url(section, format: :json)
end
