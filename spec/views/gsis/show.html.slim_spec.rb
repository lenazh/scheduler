require 'spec_helper'
require 'helpers/json_format_helper'

describe 'gsis/show' do
  let(:model_class) { User }
  let(:variable_to_assign) { :gsi }
  let(:expected_fields) { %w(id name email) }

  it_behaves_like 'a JSON show view:'

  it 'has hours_per_week assigned' do
    gsi = create(:gsi)
    gsi.hours_per_week = 42
    assign(:gsi, gsi)
    render
    result = JSON.parse rendered
    expect(result['hours_per_week']).to eq 42
  end
end
