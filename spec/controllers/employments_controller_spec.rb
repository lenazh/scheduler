require 'spec_helper'
require 'helpers/pundit_helper'

describe EmploymentsController do
  # name of the model for this RESTful resource

  let(:factory) { :employment }
  let(:url_params) { { course_id: 'course_id', email: 'gsi.email' } }
  let(:url_params_factory) { { course_id: :course_with_no_owner, email: :user } }

  # This should return the minimal set of values that should be in
  # the session in order to pass any filters (e.g. authentication) defined
  # in CoursesController. Be sure to keep this updated too.

  let(:valid_session) { {} }
  let(:hours_per_week) { 66 }
  let(:employment) { create(:employment) }
  let(:gsi) { employment.gsi }
  let(:course) { employment.course }
  let(:another_course) { create(:course) }
  let(:course_owner) { course.user }

  def params
    { id: employment.id, course_id: course.id, format: :json }
  end

  def update_gsi(params)
    put :update,
        { id: employment.id,
          course_id: course.id,
          employment: params,
          format: :json },
        valid_session
  end

  def delete_gsi
    delete :destroy, params, valid_session
  end

  include PunditHelper

  before(:each) do
    sign_in create(:user)
    CoursePolicy::Scope.any_instance.stub(:resolve) { Course.all }
    EmploymentPolicy::Scope.any_instance
      .stub(:resolveEmployments) { Employment.all }
    stub_policy(UserPolicy)
    stub_policy(EmploymentPolicy)
  end

  describe 'delete' do
    it 'returns :no_content code' do
      delete :destroy, params, valid_session
      expect(response.response_code).to eq(204)
    end

    describe 'GSI who never signed in before' do
      before(:each) do
        gsi.sign_in_count = 0
        gsi.save!
      end

      it "destroys the GSI's appointment" do
        expect { delete_gsi }.to change(Employment, :count).by(-1)
      end

      describe 'if the GSI has other appointments' do
        before(:each) do
          gsi.courses_to_teach << another_course
          gsi.save!
        end

        it "doesn't destroy the GSI" do
          expect { delete_gsi }.to change(User, :count).by(0)
        end
      end

      describe "if the GSI doesn't have other appointments" do
        it 'destroys the GSI' do
          expect { delete_gsi }.to change(User, :count).by(-1)
        end
      end
    end

    describe 'GSI who have signed in before' do
      before(:each) do
        gsi.sign_in_count = 1
        gsi.save!
      end

      it "doesn't destroy the GSI who signed in before" do
        expect { delete_gsi }.to change(User, :count).by(0)
      end

      it "destroys the GSI's appointment" do
        expect { delete_gsi }.to change(Employment, :count).by(-1)
      end
    end
  end

  describe 'update' do
    def update_and_check_if_hired(email, gsi_amount_change)
      expect do
        update_gsi(email: email, hours_per_week: hours_per_week)
      end.to change(User, :count).by(gsi_amount_change)
      new_gsi = User.find_by email: email
      expect(new_gsi.employments.first.course_id).to eq course.id
      employment = assigns(:employment)
      expect(employment.hours_per_week).to eq(hours_per_week)
      expect(employment.gsi.email).to eq(email)
    end

    describe 'with invalid email' do
      it 'returns unprocessable_entity code' do
        update_gsi(email: 'blah', hours_per_week: 12)
        expect(response.response_code).to eq(422)
      end
    end

    it 'assigns the requested model as @employment' do
      update_gsi(email: 'space@example.com', hours_per_week: 33)
      result = assigns(:employment)
      expect(result.hours_per_week).to eq 33
      expect(result.gsi.email).to eq 'space@example.com'
    end

    it 'returns success code' do
      update_gsi(email: 'space@example.com', hours_per_week: 33)
      response.should be_success
    end

    describe 'if email is changed' do
      let(:email) { 'burney@gmail.com' }

      describe 'if the updated GSI signed in before' do
        before(:each) do
          gsi.sign_in_count = 1
          gsi.save!
        end

        describe "if the new GSI doesn't exist" do
          it 'creates the new GSI without deleting the old one' do
            update_and_check_if_hired(email, 1)
          end
        end

        describe 'if the new GSI exists' do
          it 'enrolls the new GSI without deleting the old one' do
            create(:user, email: email)
            update_and_check_if_hired(email, 0)
          end
        end
      end

      describe 'if the updated GSI never signed in before' do
        before(:each) do
          gsi.sign_in_count = 0
          gsi.save!
        end

        describe 'if the updated GSI has other appointments' do
          before(:each) do
            gsi.courses_to_teach << another_course
            gsi.save!
          end

          describe "if the new GSI doesn't exist" do
            it 'creates the new GSI witout deleting the old one' do
              update_and_check_if_hired(email, 1)
            end
          end

          describe 'if the new GSI exists' do
            it 'enrolls the new GSI without deleting the old one' do
              create(:user, email: email)
              update_and_check_if_hired(email, 0)
            end
          end
        end

        describe "if the updated GSI doesn't have other appointments" do
          describe "if the new GSI doesn't exist" do
            it 'creates the new GSI and deletes the old one' do
              update_and_check_if_hired(email, 0)
            end
          end

          describe 'if the new GSI exists' do
            it 'enrolls the new GSI and deletes the old one' do
              create(:user, email: email)
              update_and_check_if_hired(email, -1)
            end
          end
        end
      end
    end
  end

  describe 'GET index' do
    it 'assigns all employments as @employments' do
      get :index, { course_id: course.id, format: :json }, valid_session
      assigns(:employments).should eq([employment])
    end
  end

  describe 'GET show' do
    it 'assigns the requested employment as @employment' do
      get :show, params, valid_session
      assigns(:employment).should eq(employment)
    end
  end
end
