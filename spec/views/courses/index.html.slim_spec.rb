require 'spec_helper'
require 'helpers/json_format_helper'

describe "courses/index" do
  let (:model_class) { Course }
  it_behaves_like 'a JSON index view:'
end
