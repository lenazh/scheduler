require 'spec_helper'
require 'helpers/json_format_helper'

describe 'gsis/show' do
  let(:model_class) { User }
  let(:variable_to_assign) { :gsi }
  it_behaves_like 'a JSON show view:'

  it 'has hours_per_week assigned' do
    gsi = create(:gsi)
    assign(:gsi, gsi)
    assign(:hours_per_week, 42)
    render
    result = JSON.parse rendered
    expect(result['hours_per_week']).to eq 42
  end
end
