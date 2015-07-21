require 'spec_helper'

describe SectionsController do
  # name of the model for this RESTful resource
  let(:factory) { :section }
  let(:url_params) { { course_id: 'course.id' } }
  let(:url_params_factory) { { course_id: :course } }

  # This should return the minimal set of values that should be in
  # the session in order to pass any filters (e.g. authentication) defined
  # in CoursesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  it_behaves_like 'a JSON resource controller:'
end
