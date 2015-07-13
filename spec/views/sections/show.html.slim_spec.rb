require 'spec_helper'
require 'helpers/json_format_helper'

describe 'sections/show' do
  let(:model_class) { Section }
  it_behaves_like 'a JSON show view:'
end
