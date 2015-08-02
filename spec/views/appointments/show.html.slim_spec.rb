require 'spec_helper'
require 'helpers/json_format_helper'

describe 'appointments/show' do
  let(:course) { stub_model(Course, attributes_for(:course)) }
  let(:user) { stub_model(User, attributes_for(:user)) }
  let(:appointment) { stub_model(Employment, gsi: user, course: course) }

  it 'assigns variables correctly' do
    assign(:appointment, appointment)
    render
    result = JSON.parse rendered
    expect(result['id']).to eq course.id
    expect(result['name']).to eq course.name
    expect(result['created_at']).to eq course.created_at
  end
end
