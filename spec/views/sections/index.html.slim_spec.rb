require 'spec_helper'
require 'helpers/json_format_helper'

describe 'sections/index' do
  let(:model_class) { Section }

  before(:each) do
    assign(:course, stub_model(Course, attributes_for(:course)))
  end

  it_behaves_like 'a JSON index view:'
end
