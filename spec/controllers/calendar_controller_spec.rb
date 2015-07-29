require 'spec_helper'
require 'helpers/route_helper'

describe CalendarController do
  include RouteHelper

  before(:each) do
    sign_in create(:user)
  end

  it 'responds to all valid routes' do
    expect_to_respond_to %w(calendar_template event_template)
  end
end
