require 'helpers/json_format_helper'

shared_examples "a JSON index view:" do
  include JsonFormatHelper

  let (:model_string) { model_class.to_s.underscore}
  let (:model_symbol) { model_string.to_sym}
  let (:models_symbol) { model_string.pluralize.to_sym}
  let (:another_model_symbol) { "another_#{model_string}".to_sym}
  let (:mock_attributes) {[attributes_for(model_symbol), attributes_for(another_model_symbol)]}

  before(:each) do
    assign(models_symbol, mock_attributes.map { |x| stub_model(model_class, x)})
  end

  it "renders a list of courses" do
    render
    result = JSON.parse rendered
    attributes_match result
  end
end