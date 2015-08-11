json.extract! @section, :id, :name, :lecture, :start_hour, :start_minute, :duration_hours, :weekday, :room, :created_at, :updated_at
if @section.gsi
  gsi = @section.gsi
  json.gsi do
    json.extract! gsi, :id, :name, :email
    json.preference gsi.preference(@section)
  end
end

preferences = @section.preferences.sort { |x, y| y.preference <=> x.preference }
json.available_gsis do
  json.array!(preferences) do |preference|
    gsi = preference.user
    json.extract! gsi, :id, :name
    json.extract! preference, :preference
    json.hours_per_week gsi.hours(@course)
  end
end

json.preference @user.preference(@section)