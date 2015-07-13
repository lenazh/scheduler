require 'spec_helper'
require 'helpers/json_format_helper'

describe 'users/index' do
  let(:model_class) { User }
  it_behaves_like 'a JSON index view:'
end
