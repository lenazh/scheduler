require 'spec_helper'

describe 'preferences/show' do
  let(:model_class) { Preference }
  let(:variable_to_assign) { :preference }
  let(:expected_fields) { %w(id preference updated_at created_at) }

  it_behaves_like 'a JSON show view:'

end
