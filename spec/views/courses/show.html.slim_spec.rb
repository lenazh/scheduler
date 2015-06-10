require 'spec_helper'

describe "courses/show" do
  let (:model_class) { Course }
  it_behaves_like 'a JSON show view:'
end
