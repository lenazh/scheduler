require 'spec_helper'
require 'helpers/route_helper'

describe MainController do
  let(:user) { create(:user) }
  before(:each) do
    sign_in user
  end

  describe 'GET index' do
    it 'makes path variables available to JS'
  end

  include RouteHelper

  it 'responds to all valid routes' do
    expect_to_respond_to %w(index courses gsi calendar)
  end

end
