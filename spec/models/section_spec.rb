require 'spec_helper'

describe Section do
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  describe "that is valid should have" do
    subject { create(:section, course: course, gsi: user) }

    it { should be_valid }
    its (:name) { should_not be_empty }
    its (:lecture) { should_not be_empty }
    its (:start_time) { should_not be_nil }
    its (:end_time) { should_not be_nil }
    its (:weekday) { should_not be_nil }

    its (:course) { should_not be_nil }
    its (:gsi) { should_not be_nil }
    its (:potential_gsis) { should respond_to :[] }
  end

  describe "is invalid if" do
    after(:each) { @section.should_not be_valid }

    it "name is empty" do
      @section = build(:section, name: " ")
    end

    it "room is empty" do
      @section = build(:section, room: " ")
    end

    it "end time is earlier than start time" do
      @section = build(:section, start_time: "9:00", end_time: "8:00") 
    end

    it "lecture is empty" do
      @section = build(:section, lecture: " ") 
    end

    it "weekday is empty" do
      @section = build(:section, weekday: " ") 
    end

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
