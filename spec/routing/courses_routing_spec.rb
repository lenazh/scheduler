require 'spec_helper'

describe CoursesController do
  describe 'routing' do

    it 'routes to #index' do
      get('/api/courses').should route_to('courses#index', format: :json)
    end

    it 'routes to #show' do
      get('/api/courses/1').should route_to(
        'courses#show', format: :json, id: '1')
    end

    it 'routes to #create' do
      post('/api/courses').should route_to('courses#create', format: :json)
    end

    it 'routes to #update' do
      put('/api/courses/1').should route_to(
        'courses#update', format: :json, id: '1')
    end

    it 'routes to #destroy' do
      delete('/api/courses/1').should route_to(
        'courses#destroy', format: :json, id: '1')
    end

  end
end
