module CalendarHelpers
  # returns the calendar cell HTML ID attribute given hour and weekday
  def calendar_cell_id(hour, weekday)
    weekday + hour.gsub(/:/, '')
  end
end

World(CalendarHelpers)
