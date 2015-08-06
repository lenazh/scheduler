require 'spec_helper'

describe PreferencesController do
  describe 'routing' do
    it 'routes to #get' do
      get('/api/courses/1/preferences/get').should route_to(
        'preferences#get',
        format: :json, course_id: '1')
    end

    it 'routes to #set' do
      put('/api/courses/1/preferences/set').should route_to(
        'preferences#set',
        format: :json, course_id: '1')
    end
  end
end
