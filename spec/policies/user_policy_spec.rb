require 'spec_helper'

describe UserPolicy do

  let(:user) { create(:user) }
  let(:gsi) { create(:gsi) }
  let(:owner) { gsi.courses_to_teach.first.user }

  subject { described_class }

  [:show?, :create?].each do |permission|
    permissions permission do
      it 'grants access to anyone' do
        expect(subject).to permit(user, gsi)
      end
    end
  end

  [:update?, :destroy?].each do |permission|
    permissions permission do
      describe "if GSI has't signed in and only enrolled in owner's class" do
        it 'grants access' do
          expect(subject).to permit(owner, gsi)
        end
      end

      describe 'if gsi logged in before' do
        it 'denies access' do
          gsi.sign_in_count = 1
          gsi.save!
          expect(subject).not_to permit(owner, gsi)
        end
      end

      describe 'if gsi has multiple enrollments' do
        it 'denies access' do
          gsi.courses_to_teach << create(:course)
          gsi.save!
          expect(subject).not_to permit(owner, gsi)
        end
      end

      describe 'if gsi is enrolled in a class not belonging to user' do
        it 'denies access' do
          expect(subject).not_to permit(user, gsi)
        end
      end
    end
  end
end
