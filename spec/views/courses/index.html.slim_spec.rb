require 'spec_helper'
require 'helpers/json_format_helper'

describe 'courses/index' do
  before(:each) do
    @user = stub_model(User, attributes_for(:user))
    @user.stub(:teaching_course?).and_return(false)
    @user.stub(:owns_course?).and_return(true)
    controller.stub(:current_user).and_return(@user)
  end

  let(:model_class) { Course }
  let(:variable_to_assign) { :courses }
  let(:expected_fields) { %w(id name created_at) }

  it_behaves_like 'a JSON index view:'

  describe '@courses' do
    before(:each) do
      assign(:courses, [create(:course), create(:another_course)])
      render
      @result = JSON.parse rendered
    end

    it 'reports creation date for each course' do
      @result.each { |entry| expect(entry['created_at']).to_not be_nil }
    end

    it 'sets is_teaching flag' do
      @result.each { |entry| expect(entry['is_teaching']).to be false }
    end

    it 'sets is_owned flag' do
      @result.each { |entry| expect(entry['is_owned']).to be true }
    end
  end
end
