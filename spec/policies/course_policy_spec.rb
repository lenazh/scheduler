require 'spec_helper'

describe CoursePolicy do

  let(:user) { User.new }
  let(:course) { create(:course) }

  subject { described_class }

  permissions '.scope' do
    it 'returns all courses owned by that user' do
      scope = Pundit.policy_scope(course.user, Course)
      expect(scope.first.id).to eq course.id
    end
  end

  [:show?, :create?, :update?, :destroy?].each do |permission|
    permissions permission do
      describe 'if user owns the record' do
        it 'grants access' do
          expect(subject).to permit(course.user, course)
        end
      end

      describe 'if user does not own the record' do
        it 'denies access' do
          expect(subject).not_to permit(user, course)
        end
      end
    end
  end
end
