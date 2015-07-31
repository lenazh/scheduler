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
      describe "if GSI has't logged in and is not teaching anything" do
        it 'grants access' do
          expect(subject).to permit(owner, user)
        end
      end

      describe 'if GSI logged in before' do
        it 'denies access' do
          user.sign_in_count = 1
          user.save!
          expect(subject).not_to permit(owner, user)
        end
      end

      describe 'if GSI is teaching a class' do
        it 'denies access' do
          expect(subject).not_to permit(owner, gsi)
        end
      end
    end
  end
end
