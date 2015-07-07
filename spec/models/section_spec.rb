require 'spec_helper'

describe Section do
  let(:user) { build(:user) }
  let(:course) { build(:course) }

  describe "that is valid" do
    before(:each) do
      @section = build(:section, user: user, course: course)
      @section.should be_valid
    end

    it "has a name" { expect(@section.name).not_to be_empty }
    it "has an owner" { expect(@section.user).not_to be_empty }
    it "has an assigned GSI" { expect(@section.gsi).not_to be_empty }
    it "is part of a lecture" { expect(@section.lecture).not_to be_empty }
    it "has a start time" { expect(@section.start_time).not_to be_empty }
    it "has an end time" { expect(@section.end_time).not_to be_empty }
    it "has a weekday" { expect(@section.weekday).not_to be_empty }

    it "belongs to a Course" { expect(@section.course).not_to be_empty }
    it "belongs to a GSI (User)" { expect(@section.gsi).not_to be_empty }
    it "has many potential_GSIs (Users)" { expect(@section.potential_gsis).to be_kind_of(Array) }
  end

  describe "is invalid if" do

    after(:each) { @section.should_not be_valid }

    it "name is empty" { @section = build(:section, name: " ") }
    it "room is empty" { @section = build(:section, room: " ") }
    it "end time is earlier than start time" { @section = build(:section, start_time: "9:00", end_time: "8:00") }
    it "lecture is empty" { @section = build(:section, lecture: " ") } 
    it "weekday is empty" { @section = build(:section, weekday: " ") }
    it "a section with the same name exists in the same course" do
      section = create(:section, name: "103", course_id: 1)
      @section = build(:section, name: "103", course_id: 1)
    end

  end


  it "should be valid if a section with the same name exists in another course" do
    section1 = create(:section, name: "103", course_id: 1)
    section2 = build(:section, name: "103", course_id: 2)
    section2.should be_valid;
  end


end
