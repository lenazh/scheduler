require 'spec_helper'

describe SectionsController do
    # name of the model for this RESTful resource
    let(:model_class) { Section }
    let(:parent) { create(:course) }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # CoursesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    it_behaves_like 'a JSON resource controller:'
end
