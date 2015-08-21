require 'spec_helper'

describe PreferencePolicy do

  let(:user) { create(:user) }
  let(:section) { create(:section) }
  let(:gsi) do
    gsi = create(:user, name: 'Snoopy')
    create(:employment, course: section.course, gsi: gsi)
    create(:preference, user_id: gsi.id, section_id: section.id)
    gsi
  end
  let(:course) { section.course }
  let(:owner) { course.user }

  subject { described_class }

  permissions :create? do
    let(:preference) { build(:preference, section_id: section.id) }
    describe 'if user enrolled as a gsi in that course' do
      it 'grants access' do
        expect(subject).to permit(gsi, preference)
      end
    end

    describe 'if user owns the course that the section belongs to' do
      it 'grants access' do
        expect(subject).to permit(gsi, preference)
      end
    end

    describe "if user doesn't teach the course nor owns it" do
      it 'denies access' do
        expect(subject).not_to permit(user, preference)
      end
    end
  end

  [:show?, :update?, :destroy?].each do |permission|
    permissions permission do
      let(:preference) { gsi.preferences.first }
      describe 'if user owns the course that the section belongs to' do
        it 'grants access' do
          expect(subject).to permit(owner, preference)
        end
      end

      describe 'if user is the gsi teaching that course' do
        it 'grants access' do
          expect(subject).to permit(gsi, preference)
        end
      end

      describe "if user doesn't teach the course nor owns it" do
        it 'denies access' do
          expect(subject).not_to permit(user, preference)
        end
      end
    end
  end
end
