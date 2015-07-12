class CalendarController < ApplicationController
  def calendar_template; render layout: false; end
  def event_template; render layout: false; end
end