require 'spec_helper'

describe MainController do
  describe 'routing' do
    it 'routes to #index' do
      get('/').should route_to('main#index')
    end

    it 'routes to #gsi' do
      get('/gsi').should route_to('main#gsi')
    end

    it 'routes to #calendar' do
      get('/calendar').should route_to('main#calendar')
    end
  end
end
