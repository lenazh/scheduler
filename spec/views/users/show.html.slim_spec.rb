require 'spec_helper'

describe 'users/show' do
  let(:model_class) { User }
  it_behaves_like 'a JSON show view:'
end
