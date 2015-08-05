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
    stub_policy(PreferencePolicy)
    CoursePolicy::Scope.any_instance.stub(:resolve) { Course.all }
    PreferencePolicy::Scope.any_instance.stub(:resolve) { Preference.all }
  end

  describe do
    before(:each) do
      sign_in create(:user)
    end

    it_behaves_like 'a JSON resource controller:'
  end

  describe do
    let(:preference) { create(:preference) }
    let(:section) { preference.section }
    let(:course) { section.course }
    let(:user) { preference.user }

    before(:each) do
      sign_in user
    end

    describe 'get()' do
      def get_preference
        get :get,
            {
              course_id: course.id,
              section_id: section.id,
              format: :json
            },
            valid_session
      end

      it 'assigns @preference variable' do
        get_preference
        expect(assigns(:preference)).to eq(preference)
      end

      it 'returns 200' do
        get_preference
        expect(response.response_code).to eq(200)
      end
    end

    describe 'set()' do
      def set_preference(preference, section)
        put :set,
            {
              course_id: course.id,
              section_id: section.id,
              preference: preference,
              format: :json
            },
            valid_session
      end

      describe 'with valid parameters' do
        describe 'if the record existed' do
          it 'updates the record' do
            expect { set_preference(0.76, section) }.
              to change(Preference, :count).by(0)
            preference.reload
            expect(preference.preference).to eq(0.76)
          end
        end

        describe "if the record didn't exist" do
          it 'creates a new record' do
            new_section = create(:section_without_course)
            course.sections << new_section
            course.save!
            expect { set_preference(0.16, new_section) }.
              to change(Preference, :count).by(1)
            new_section.reload
            new_preference = assigns(:preference).preference
            expect(new_preference).to be_within(1e-3).of 0.16
          end
        end

        it 'returns 201' do
          set_preference(0.45, section)
          expect(response.response_code).to eq(201)
        end

        it 'assigns @preference variable' do
          set_preference(0.145, section)
          preference = assigns(:preference)
          expect(preference.preference).to be_within(1e-3).of 0.145
          expect(preference.user).to eq user
          expect(preference.section).to eq section
        end
      end

      describe 'with invalid parameters' do
        it 'returns 422' do
          Preference.any_instance.stub(:save).and_return(false)
          set_preference(-1, section)
          expect(response.response_code).to eq(422)
        end
      end
    end
  end
end
