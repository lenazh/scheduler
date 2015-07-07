require 'spec_helper'

describe Course do
  describe "that is valid" do
    before(:each) do
      @course = build(:course)
      @course.should be_valid
    end

    it "should have a name" { expect(@course.name).not_to be_empty }
    it "should have an owner" { expect(@course.user).not_to be_empty }
  end

  it "should be invalid if the name is empty" do
    course = build(:course, name: "  ")
    course.should_not be_valid
  end
end
