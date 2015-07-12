require 'spec_helper'

describe Section do
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  describe "that is valid should have" do
    subject { create(:section, course: course, gsi: user) }

    it { should be_valid }
    its (:name) { should_not be_empty }
    its (:lecture) { should_not be_empty }
    its (:start_hour) { should_not be_nil }
    its (:start_minute) { should_not be_nil }
    its (:duration_hours) { should_not be_nil }
    its (:start_hour) { should be > 0 }
    its (:duration_hours) { should be > 0 }
    its (:weekday) { should_not be_nil }

    its (:course) { should_not be_nil }
    its (:gsi) { should_not be_nil }
    its (:potential_gsis) { should respond_to :[] }
  end

  describe "is invalid if" do
    after(:each) { @section.should_not be_valid }

    it "name is empty" do; @section = build(:section, name: " "); end
    it "room is empty" do; @section = build(:section, room: " "); end
    it "lecture is empty" do; pending; @section = build(:section, lecture: " "); end
    it "weekday is empty" do; @section = build(:section, weekday: " "); end

    it "a section with the same name exists in the same course" do
      section = create(:section, name: "103", course_id: 1)
      @section = build(:section, name: "103", course_id: 1)
    end

    it "start_hour is negative" do; @section = build(:section, start_hour: -3); end
    it "start_hour is > 23" do; @section = build(:section, start_hour: 64); end
    it "start_minute is negative" do; @section = build(:section, start_minute: -8); end
    it "start_minute is > 59" do; @section = build(:section, start_minute: 64); end
    it "duration_hours is negative" do; @section = build(:section, duration_hours: -5); end
    it "duration_hours is > 10" do; @section = build(:section, duration_hours: 15); end

  end


  it "should be valid if a section with the same name exists in another course" do
    section1 = create(:section, name: "103", course_id: 1)
    section2 = build(:section, name: "103", course_id: 2)
    section2.should be_valid;
  end


end
