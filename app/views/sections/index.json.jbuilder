json.array!(@sections) do |section|
  json.extract! section, :id, :name, :lecture, :start_time, :end_time, :gsi_id, :weekday, :room
  json.url section_url(section, format: :json)
end
