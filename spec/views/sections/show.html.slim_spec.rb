require 'spec_helper'
require 'helpers/json_format_helper'

describe 'sections/show' do
  let(:model_class) { Section }
  let(:variable_to_assign) { :section }
  let(:expected_fields) do
    %w(id name start_hour start_minute duration_hours weekday room)
  end

  before(:each) do
    @user = stub_model(User, attributes_for(:user))
    @user.stub(:preference).and_return('1.0')
    controller.stub(:current_user).and_return(@user)
  end

  it_behaves_like 'a JSON show view:'
end
