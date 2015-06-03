require 'spec_helper'

describe Section do
  it "should be invalid if the name is empty" do
    section = build(:section, name: " ");
    section.should_not be_valid;
  end

  it "should have a unique name within the same class" do
    section1 = create(:section, name: "103", class_id: 1);
    section2 = build(:section, name: "103", class_id: 1);
    section2.should_not be_valid;
  end

  it "may have duplicate names as long as the classes are different" do
    section1 = create(:section, name: "103", class_id: 1);
    section2 = build(:section, name: "103", class_id: 2);
    section2.should be_valid;
  end

  it "should be invalid if the room is not specified" do
    section = build(:section, room: " ");
    section.should_not be_valid;
  end

  it "should be invalid if the end time is earlier than start time" do
    section = build(:section, start_time: "9:00", end_time: "8:00");
    section.should_not be_valid;
  end

  it "should be invalid if the lecture is not specified" do
    pending "Lecture model does not exist"
  end

  it "should be valid as long as all the necessary parameters are specified" do
    section = build(:section);
    section.should be_valid;
  end
end
