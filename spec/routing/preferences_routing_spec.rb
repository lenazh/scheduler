require 'spec_helper'

describe PreferencesController do
  describe 'routing' do

    it 'routes to #index' do
      get('/api/courses/1/preferences').should route_to(
        'preferences#index',
        format: :json, course_id: '1')
    end

    it 'routes to #show' do
      get('/api/courses/1/preferences/1').should route_to(
        'preferences#show',
        format: :json, id: '1', course_id: '1')
    end

    it 'routes to #create' do
      post('/api/courses/1/preferences').should route_to(
        'preferences#create',
        format: :json, course_id: '1')
    end

    it 'routes to #update' do
      put('/api/courses/1/preferences/1').should route_to(
        'preferences#update',
        format: :json, id: '1', course_id: '1')
    end

    it 'routes to #destroy' do
      delete('/api/courses/1/preferences/1').should route_to(
        'preferences#destroy',
        format: :json, id: '1', course_id: '1')
    end

  end
end
