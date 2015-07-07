require 'spec_helper'
require 'helpers/route_helper'

describe CalendarController do
  include RouteHelper

  it "responds to all valid routes" do
    expect_to_respond_to ['calendar_template']
  end

end
