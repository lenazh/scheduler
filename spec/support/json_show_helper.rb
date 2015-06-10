require 'helpers/json_format_helper'

shared_examples "a JSON show view:" do
  include JsonFormatHelper

  let (:model_string) { model_class.to_s.underscore}
  let (:model_symbol) { model_string.to_sym}
  let (:mock_attributes) { attributes_for model_symbol }

  before(:each) do
    @course = assign(model_symbol, stub_model(model_class, mock_attributes))
  end

  it "renders attributes" do
    render
    result = JSON.parse rendered
    attributes_match result
  end
end