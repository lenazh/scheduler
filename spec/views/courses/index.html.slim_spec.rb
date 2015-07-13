require 'spec_helper'
require 'helpers/json_format_helper'

describe 'courses/index' do
  let(:model_class) { Course }
  it_behaves_like 'a JSON index view:'

  it 'reports creation date for each course' do
    my_courses = [create(:course), create(:another_course)]
    assign(:courses, my_courses)
    render
    result = JSON.parse rendered
    result.each do |entry|
      expect(entry['created_at']).to_not be_nil
    end
  end
end
