require 'spec_helper'

describe GsisController do
  # name of the model for this RESTful resource
  let(:factory) { :gsi }
  let(:url_params) { { course_id: 'courses_to_teach.first.id' } }
  let(:url_params_factory) { { course_id: :course_with_no_owner } }

  # This should return the minimal set of values that should be in
  # the session in order to pass any filters (e.g. authentication) defined
  # in CoursesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:course) do
    course = create(:course)
    course.gsis << gsi
    employment = course.employments.first
    employment.hours_per_week = hours_per_week
    employment.save!
    course
  end

  let(:hours_per_week) { 66 }
  let(:gsi) { create(:user) }

  describe 'GET show' do
    it 'sets @hours_per_week variable' do
      get :show,
          { id: gsi.id, course_id: course.id, format: :json },
          valid_session
      expect(assigns(:hours_per_week)).to eq hours_per_week
    end
  end

  describe 'GET index' do
    it 'sets hours_per_week variable for each gsi in @gsis' do
      get :index, { course_id: course.id, format: :json }, valid_session
      expect(assigns(:gsis)[0].hours_per_week).to eq hours_per_week
    end
  end

  describe 'update' do
    it 'updates hours_per_week if the parameter is present' do
      put :update,
          { id: gsi.id,
            course_id: course.id,
            gsi: { hours_per_week: 77 },
            format: :json },
          valid_session
      gsi_db = User.find(gsi.id)
      expect(gsi_db.employments.first.hours_per_week).to eq 77
    end

    it 'sets @hours_per_week variable if parameter is present' do
      put :update,
          { id: gsi.id,
            course_id: course.id,
            gsi: { hours_per_week: 77 },
            format: :json },
          valid_session
      gsi_db = User.find(gsi.id)
      expect(assigns(:hours_per_week)).to eq 77
    end

    it "doesn't reset hours_per_week if the parameter is missing" do
      put :update,
          { id: gsi.id,
            course_id: course.id,
            gsi: { name: 'Burney' },
            format: :json },
          valid_session
      gsi_db = User.find(gsi.id)
      expect(gsi_db.employments.first.hours_per_week).to eq hours_per_week
    end
  end

  it_behaves_like 'a JSON resource controller:'
end
