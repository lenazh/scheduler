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

  let(:hours_per_week) { 66 }
  let(:gsi) do
    gsi = create(:gsi)
    employment = gsi.employments.first
    employment.hours_per_week = hours_per_week
    employment.save!
    gsi
  end
  let(:course) { gsi.courses_to_teach.first }
  let(:course_owner) { course.user }
  let(:employment) { gsi.employments.first }

  def update_gsi(params)
    put :update,
        { id: gsi.id,
          course_id: course.id,
          gsi: params,
          format: :json },
        valid_session
  end

  def delete_gsi()
    delete :destroy,
           { id: gsi.id, course_id: course.id, format: :json },
           valid_session
  end


  before(:each) do
    sign_in create(:user)
  end

  describe 'GET show' do
    it 'sets @gsi.hours_per_week variable' do
      get :show,
          { id: gsi.id, course_id: course.id, format: :json },
          valid_session
      gsi = assigns(:gsi)
      expect(assigns(:gsi).hours_per_week).to eq hours_per_week
    end
  end

  describe 'GET index' do
    it 'sets hours_per_week variable for each gsi in @gsis' do
      get :index, { course_id: course.id, format: :json }, valid_session
      expect(assigns(:gsis)[0].hours_per_week).to eq hours_per_week
    end
  end

  describe 'delete' do
    describe 'GSI who never signed in before' do
      before(:each) do
        gsi.sign_in_count = 0
        gsi.save!
      end

      it "destroys the GSI" do
        expect{ delete_gsi }.to change(User, :count).by(-1)
      end

      it "destroys the GSI's appointment" do
        expect{ delete_gsi }.to change(Employment, :count).by(-1)
      end      
    end

    describe 'GSI who have signed in before' do
      before(:each) do
        gsi.sign_in_count = 1
        gsi.save!
      end

      it "doesn't destroy the GSI who signed in before" do      
        expect{ delete_gsi }.to change(User, :count).by(0)     
      end

      it "destroys the GSI's appointment" do
        expect{ delete_gsi }.to change(Employment, :count).by(-1)
      end
    end
  end


  describe 'update' do
    describe 'if email is changed' do
      it "creates a new GSI if the updated gsi signed in before" do
        gsi.sign_in_count = 1
        gsi.save!
        expect { update_gsi({ email: 'Burney@gmail.com' }) }
          .to change(User, :count).by(1)
      end

      it 'updates the existing GSI if he never signed in' do
        gsi.sign_in_count = 0
        gsi.save!
        expect { update_gsi({ email: 'Burney@gmail.com' }) }
          .to change(User, :count).by(0)
        gsi.reload
        expect(gsi.email).to eq('burney@gmail.com')
      end
    end

    it 'updates hours_per_week if the parameter is present' do
      update_gsi({ hours_per_week: 77 })
      gsi_db = User.find(gsi.id)
      expect(gsi_db.employments.first.hours_per_week).to eq 77
    end

    it 'sets @gsi.hours_per_week variable if parameter is present' do
      update_gsi({ hours_per_week: 77 })
      gsi_db = User.find(gsi.id)
      expect(assigns(:gsi).hours_per_week).to eq 77
    end

    it "doesn't reset hours_per_week if the parameter is missing" do
      update_gsi({ email: 'Burney@gmail.com' })
      gsi_db = User.find(gsi.id)
      expect(gsi_db.employments.first.hours_per_week).to eq hours_per_week
    end
  end
  it_behaves_like 'a JSON resource controller:'
end
