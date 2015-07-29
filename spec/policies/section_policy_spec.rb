require 'spec_helper'

describe SectionPolicy do

  let(:user) { create(:user) }
  let(:section) { create(:section) }

  subject { described_class }

  [:show?, :create?, :update?, :destroy?].each do |permission|
    permissions permission do
      describe 'if user owns the record' do
        it 'grants access' do
          expect(subject).to permit(section.course.user, section)
        end
      end

      describe 'if user does not own the record' do
        it 'denies access' do
          expect(subject).not_to permit(user, section)
        end
      end
    end
  end
end
