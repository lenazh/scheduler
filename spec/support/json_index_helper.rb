require 'helpers/json_format_helper'

shared_examples 'a JSON index view:' do
  include JsonFormatHelper

  let(:model_string) { model_class.to_s.underscore }
  let(:model_symbol) { model_string.to_sym }
  let(:another_model_symbol) { "another_#{model_string}".to_sym }
  let(:mock_attributes) do
    [attributes_for(model_symbol), attributes_for(another_model_symbol)]
  end

  before(:each) do
    assign(variable_to_assign,
           mock_attributes.map { |x| stub_model(model_class, x) })
  end

  it 'renders a list of courses' do
    render
    result = JSON.parse rendered
    attributes_match result, mock_attributes
  end
end
