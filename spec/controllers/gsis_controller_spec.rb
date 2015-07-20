require 'spec_helper'

describe GsisController do
  # name of the model for this RESTful resource
  let(:factory) { :gsi }
  let(:url_params) { { course_id: "courses_to_teach.first.id"} }
  let(:url_params_factory) { { course_id: :course_with_no_owner } }

  # This should return the minimal set of values that should be in
  # the session in order to pass any filters (e.g. authentication) defined
  # in CoursesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  it_behaves_like 'a JSON resource controller:'
end
