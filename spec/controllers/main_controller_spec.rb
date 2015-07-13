require 'spec_helper'
require 'helpers/route_helper'

describe MainController do
  describe 'GET index' do
    it 'makes path variables available to JS'
  end

  include RouteHelper

  it 'responds to all valid routes' do
    expect_to_respond_to %w(index courses gsi preferences calendar)
  end

end
