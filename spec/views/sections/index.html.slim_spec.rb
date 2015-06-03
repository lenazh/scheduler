require 'spec_helper'

describe "sections/index" do
  before(:each) do
    assign(:sections, [
      stub_model(Section,
        :name => "",
        :lecture_id => "",
        :start_time => "",
        :end_time => "",
        :gsi_id => "",
        :weekday => 1
      ),
      stub_model(Section,
        :name => "",
        :lecture_id => "",
        :start_time => "",
        :end_time => "",
        :gsi_id => "",
        :weekday => 1
      )
    ])
  end

  it "renders a list of sections" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
