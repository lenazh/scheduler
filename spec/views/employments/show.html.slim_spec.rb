require 'spec_helper'
require 'helpers/json_format_helper'

describe 'employments/show' do
  let(:course) { stub_model(Course, attributes_for(:course)) }
  let(:user) { stub_model(User, attributes_for(:user)) }
  let(:employment) { stub_model(Employment, gsi: user, course: course) }

  it 'assigns variables correctly' do
    assign(:employment, employment)
    render
    result = JSON.parse rendered
    expect(result['id']).to eq employment.id
    expect(result['name']).to eq user.name
    expect(result['email']).to eq user.email
    expect(result['created_at']).to eq employment.created_at
  end
end
