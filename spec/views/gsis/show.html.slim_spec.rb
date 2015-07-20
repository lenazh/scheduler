require 'spec_helper'
require 'helpers/json_format_helper'

describe 'gsis/show' do
  let(:model_class) { User }
  let(:variable_to_assign) { :gsi }
  it_behaves_like 'a JSON show view:'
end
