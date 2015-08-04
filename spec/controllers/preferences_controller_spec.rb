require 'spec_helper'
require 'helpers/pundit_helper'

describe PreferencesController do
  # name of the model for this RESTful resource
  let(:factory) { :preference }
  let(:url_params) { { course_id: 'section.course.id' } }
  let(:url_params_factory) { { course_id: :course } }

  # This should return the minimal set of values that should be in
  # the session in order to pass any filters (e.g. authentication) defined
  # in CoursesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  include PunditHelper

  before(:each) do
    sign_in create(:user)
    stub_policy(PreferencePolicy)
    CoursePolicy::Scope.any_instance.stub(:resolve) { Course.all }
    PreferencePolicy::Scope.any_instance.stub(:resolve) { Preference.all }
  end

  it_behaves_like 'a JSON resource controller:'
end
