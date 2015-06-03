json.array!(@sections) do |section|
  json.extract! section, :id, :name, :lecture_id, :start_time, :end_time, :gsi_id, :weekday
  json.url section_url(section, format: :json)
end
