require 'spec_helper'

describe AppointmentsController do
  describe 'routing' do
    it 'routes to #index' do
      get('/api/appointments').should route_to('appointments#index', format: :json)
    end

    it 'routes to #show' do
      get('/api/appointments/1').should route_to(
        'appointments#show', format: :json, id: '1')
    end
  end
end