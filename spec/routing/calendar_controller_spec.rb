require 'spec_helper'

describe CalendarController do
  describe 'routing' do
    it 'routes to #calendar_template' do
      get('calendar_template.html').
        should route_to('calendar#calendar_template')
    end

    it 'routes to #event_template' do
      get('event_template.html').should route_to('calendar#event_template')
    end

    it 'routes to #preference_template' do
      get('preference_template.html').
        should route_to('calendar#preference_template')
    end
  end
end
