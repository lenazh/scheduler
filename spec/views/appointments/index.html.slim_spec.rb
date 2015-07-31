require 'spec_helper'

describe 'appointments/index' do
  def match_mock(result, mock)
    expect(result['id']).to eq mock.course.id
    expect(result['name']).to eq mock.course.name
    expect(result['created_at']).to eq mock.course.created_at
  end

  let(:course_1) { stub_model(Course, attributes_for(:course)) }
  let(:course_2) { stub_model(Course, attributes_for(:another_course)) }
  let(:user) { stub_model(User, attributes_for(:user)) }
  let(:appointment_1) { stub_model(Employment, gsi: user, course: course_1) }
  let(:appointment_2) { stub_model(Employment, gsi: user, course: course_2) }

  it 'assigns variables correctly' do
    mocks = [appointment_1, appointment_2]
    assign(:appointments, mocks)
    render
    results = JSON.parse rendered
    results.each_with_index do |result, id|
      match_mock(result, mocks[id])
    end
  end
end