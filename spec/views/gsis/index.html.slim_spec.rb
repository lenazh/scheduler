require 'spec_helper'
require 'helpers/json_format_helper'

describe 'gsis/index' do
  let(:model_class) { User }
  let(:variable_to_assign) { :gsis }
  let(:expected_fields) { %w(id name email) }

  before(:each) do
    assign(:course, stub_model(Course, attributes_for(:course)))
  end

  it_behaves_like 'a JSON index view:'

  it 'has hours_per_week assigned' do
    gsi = create(:gsi)
    gsi.hours_per_week = 42
    assign(:gsis, [gsi])
    render
    result = JSON.parse rendered
    expect(result[0]['hours_per_week']).to eq 42
  end
end
