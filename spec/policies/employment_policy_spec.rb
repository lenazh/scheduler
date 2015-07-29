require 'spec_helper'

describe EmploymentPolicy do

  let(:user) { create(:user) }
  let(:gsi) { create(:gsi) }
  let(:course) { gsi.courses_to_teach.first }
  let(:owner) { course.user }

  subject { described_class }

  permissions :create? do
    let(:employment) { build(:employment, course_id: course.id) }
    describe 'if user owns the course' do
      it 'grants access' do
        expect(subject).to permit(owner, employment)
      end
    end

    describe 'if user is the one about to be employed' do
      it 'denies access' do
        expect(subject).not_to permit(gsi, employment)
      end
    end

    describe 'if user does not own the record nor is employed' do
      it 'denies access' do
        expect(subject).not_to permit(user, employment)
      end
    end
  end

  [:show?, :update?, :destroy?].each do |permission|
    permissions permission do
      let(:employment) { gsi.employments.first }
      describe 'if user owns the course' do
        it 'grants access' do
          expect(subject).to permit(owner, employment)
        end
      end

      describe 'if user is employed' do
        it 'grants access' do
          expect(subject).to permit(gsi, employment)
        end
      end

      describe 'if user does not own the record nor is employed' do
        it 'denies access' do
          expect(subject).not_to permit(user, employment)
        end
      end
    end
  end
end
