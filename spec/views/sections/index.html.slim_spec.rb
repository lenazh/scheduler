require 'spec_helper'
require 'helpers/json_format_helper'

describe "sections/index" do
  let (:model_class) { Section }
  it_behaves_like 'a JSON index view:'
end
