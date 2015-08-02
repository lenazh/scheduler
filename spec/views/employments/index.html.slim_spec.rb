require 'spec_helper'

describe 'employments/index' do
  def match_mock(result, mock)
    expect(result['id']).to eq mock.id
    expect(result['name']).to eq mock.gsi.name
    expect(result['email']).to eq mock.gsi.email
    expect(result['created_at']).to eq mock.created_at
  end

  let(:course) { stub_model(Course, id: 13) }
  let(:user_1) { stub_model(User, attributes_for(:user)) }
  let(:user_2) { stub_model(User, attributes_for(:user)) }
  let(:employment_1) do
    stub_model(Employment, gsi: user_1, course: course, id: 34)
  end
  let(:employment_2) do
    stub_model(Employment, gsi: user_2, course: course, id: 35)
  end

  it 'assigns variables correctly' do
    mocks = [employment_1, employment_2]
    assign(:employments, mocks)
    assign(:course, course)
    render
    results = JSON.parse rendered
    results.each_with_index do |result, id|
      match_mock(result, mocks[id])
    end
  end
end
