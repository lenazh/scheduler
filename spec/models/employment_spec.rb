require 'spec_helper'

describe Employment do
  let(:gsi) { create(:user) }
  let(:course) { create(:course) }

  describe 'that is valid' do
    subject { create(:employment, gsi: gsi, course: course) }

    it { should be_valid }
    its(:course) { should_not be_nil }
    its(:gsi) { should_not be_nil }
    its(:hours_per_week) { should_not be_nil }
  end

  describe 'is invalid when' do
    describe 'hours_per_week < 0' do
      subject { build(:employment, hours_per_week: -20) }
      it { should_not be_valid }
    end

    describe 'hours_per_week > 168' do
      subject { build(:employment, hours_per_week: 2000) }
      it { should_not be_valid }
    end
  end
end
