require 'spec_helper'

describe Course do
  it "should be valid if the name is non-empty" do
    course = build(:course)
    course.should be_valid
  end

  it "should be invalid if the name is empty" do
    course = build(:course, name: "  ")
    course.should_not be_valid
  end
end
