require 'spec_helper'

describe "Sections" do
  describe "GET /course/:course_id/sections/" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      parent = create(:course)
      get course_sections_path(parent.id)
      response.status.should be(200)
    end
  end
end
