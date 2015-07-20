require 'spec_helper'

describe 'users/show' do
  let(:model_class) { User }
  let(:variable_to_assign) { :user }
  it_behaves_like 'a JSON show view:'
end
