# Controller that serves partials for AngularJS Calendar directive
class CalendarController < ApplicationController
  def calendar_template
    render layout: false
  end

  def event_template
    render layout: false
  end
end
