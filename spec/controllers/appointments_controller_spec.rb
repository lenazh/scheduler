require 'spec_helper'
require 'helpers/pundit_helper'

describe AppointmentsController do
  # This should return the minimal set of values that should be in
  # the session in order to pass any filters (e.g. authentication) defined
  # in CoursesController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let(:course1) { create(:course) }
  let(:course2) { create(:course) }
  let(:user) do
    user = create(:user)
    user.courses_to_teach << course1
    user.courses_to_teach << course2
    user.save!
    user
  end
  let(:employment) { user.employments.first }

  include PunditHelper

  before(:each) do
    sign_in user
    stub_policy(EmploymentPolicy)
    CoursePolicy::Scope.any_instance.stub(:resolve_appointments) { Course.all }
  end

  describe 'GET index' do
    it 'assigns all appointments as @appointments' do
      get :index, { format: :json }, valid_session
      appointments = assigns(:appointments)
      expect(appointments[0].course_id).to eq(course1.id)
      expect(appointments[1].course_id).to eq(course2.id)
    end
  end

  describe 'GET show' do
    it 'assigns the requested appointment as @appointment' do
      get :show, { id: employment.id, format: :json }, valid_session
      expect(assigns(:appointment).id).to eq employment.course.id
    end
  end
end
