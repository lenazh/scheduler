require 'spec_helper'

describe Course do
  let(:user) { create(:user) }

  describe "that is valid" do
    before(:each) do
      @course = create(:course, user: user, gsi: user)
      @course.should be_valid
    end

    it "has a name" { expect(@course.name).not_to be_empty }

    it "belongs to a User" { expect(@course.user).not_to be_empty }
    it "has many Sections" { expect(@course.sections).to be_kind_of(Array) }
    it "has many GSIs (Users)" { expect(@course.gsis).to be_kind_of(Array) }
  end

  it "is invalid if the name is empty" do
    course = build(:course, name: "  ")
    course.should_not be_valid
  end
end
