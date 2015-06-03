require 'spec_helper'

describe "sections/edit" do
  before(:each) do
    @section = assign(:section, stub_model(Section,
      :name => "",
      :lecture_id => "",
      :start_time => "",
      :end_time => "",
      :gsi_id => "",
      :weekday => 1
    ))
  end

  it "renders the edit section form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", section_path(@section), "post" do
      assert_select "input#section_name[name=?]", "section[name]"
      assert_select "input#section_lecture_id[name=?]", "section[lecture_id]"
      assert_select "input#section_start_time[name=?]", "section[start_time]"
      assert_select "input#section_end_time[name=?]", "section[end_time]"
      assert_select "input#section_gsi_id[name=?]", "section[gsi_id]"
      assert_select "input#section_weekday[name=?]", "section[weekday]"
    end
  end
end
