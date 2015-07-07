require 'spec_helper'

describe Section do

  describe "that is valid" do
    before(:each) do
      @section = build(:section)
      @section.should be_valid
    end

    it "should have a name" { expect(@section.name).not_to be_empty }
    it "should have an owner" { expect(@section.user).not_to be_empty }
    it "should have an assigned GSI" { expect(@section.gsi).not_to be_empty }
    it "should belong to a lecture" { expect(@section.lecture).not_to be_empty }
    it "should have a start time" { expect(@section.start_time).not_to be_empty }
    it "should have an end time" { expect(@section.end_time).not_to be_empty }
    it "should have a weekday" { expect(@section.weekday).not_to be_empty }
  end

  describe "should be invalid" do

    after(:each) { @section.should_not be_valid }

    it "if the name is empty" { @section = build(:section, name: " ") }
    it "if the room is empty" { @section = build(:section, room: " ") }
    it "if the end time is earlier than start time" { @section = build(:section, start_time: "9:00", end_time: "8:00") }
    it "if the lecture is empty" { @section = build(:section, lecture: " ") } 
    it "if the weekday is empty" { @section = build(:section, weekday: " ") }
    it "if a section with the same name exists in the same course" do
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
