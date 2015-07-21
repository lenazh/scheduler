require 'spec_helper'

describe 'GSIs' do
  describe 'GET /course/:course_id/sections/' do
    it 'works! (now write some real specs)' do
      parent = create(:course)
      get course_sections_path(parent.id)
      response.status.should be(200)
    end
  end
end
