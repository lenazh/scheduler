require 'spec_helper'

describe 'courses/show' do
  let(:model_class) { Course }
  let(:variable_to_assign) { :course }
  let(:expected_fields) { %w(id name created_at) }

  it_behaves_like 'a JSON show view:'
end
