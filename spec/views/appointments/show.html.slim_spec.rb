require 'spec_helper'
require 'helpers/json_format_helper'

describe 'appointments/show' do
  before(:each) do
    @user = stub_model(User, attributes_for(:user))
    @user.stub(:teaching_course?).and_return(true)
    @user.stub(:owns_course?).and_return(false)
    controller.stub(:current_user).and_return(@user)
  end

  let(:course) { stub_model(Course, attributes_for(:course)) }
  let(:appointment) { stub_model(Employment, gsi: @user, course: course) }

  it 'assigns variables correctly' do
    assign(:appointment, appointment)
    render
    result = JSON.parse rendered
    expect(result['id']).to eq course.id
    expect(result['name']).to eq course.name
    expect(result['created_at']).to eq course.created_at
    expect(result['is_teaching']).to be true
    expect(result['is_owned']).to be false
  end
end
