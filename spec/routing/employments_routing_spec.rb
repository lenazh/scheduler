require 'spec_helper'

describe EmploymentsController do
  describe 'routing' do
    it 'routes to #index' do
      get('/api/courses/1/employments').should route_to(
        'employments#index',
        format: :json, course_id: '1')
    end

    it 'routes to #show' do
      get('/api/courses/1/employments/1').should route_to(
        'employments#show',
        format: :json, id: '1', course_id: '1')
    end

    it 'routes to #create' do
      post('/api/courses/1/employments').should route_to(
        'employments#create',
        format: :json, course_id: '1')
    end

    it 'routes to #update' do
      put('/api/courses/1/employments/1').should route_to(
        'employments#update',
        format: :json, id: '1', course_id: '1')
    end

    it 'routes to #destroy' do
      delete('/api/courses/1/employments/1').should route_to(
        'employments#destroy',
        format: :json, id: '1', course_id: '1')
    end
  end
end
