require 'spec_helper'

describe 'courses/show' do
  before(:each) do
    @user = stub_model(User, attributes_for(:user))
    @user.stub(:teaching_course?).and_return(false)
    @user.stub(:owns_course?).and_return(true)
    controller.stub(:current_user).and_return(@user)
  end

  let(:model_class) { Course }
  let(:variable_to_assign) { :course }
  let(:expected_fields) { %w(id name created_at) }

  it_behaves_like 'a JSON show view:'

  describe '@courses' do
    before(:each) do
      assign(:course, create(:course))
      render
      @result = JSON.parse rendered
    end

    it 'reports creation date for each course' do
      expect(@result['created_at']).to_not be_nil
    end

    it 'sets is_teaching flag' do
      expect(@result['is_teaching']).to be false
    end

    it 'sets is_owned flag' do
      expect(@result['is_owned']).to be true
    end
  end
end
