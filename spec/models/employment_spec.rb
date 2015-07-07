require 'spec_helper'

describe Employment do
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  describe "that is valid" do
    before(:each) do
      @employment = create(:employment, user: user, course: course)
      @employment.should be_valid
    end

    it "belongs to a Course" { expect(@employment.course).not_to be_empty }
    it "belongs to a User" { expect(@employment.user).not_to be_empty }
  end  
end
