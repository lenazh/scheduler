require 'spec_helper'
require 'helpers/json_format_helper'

describe 'preferences/index' do
  before(:each) do
    assign(:course, stub_model(Course, attributes_for(:course)))
  end

  let(:model_class) { Preference }
  let(:variable_to_assign) { :preferences }
  let(:expected_fields) { %w(id preference updated_at created_at) }

  it_behaves_like 'a JSON index view:'

end
