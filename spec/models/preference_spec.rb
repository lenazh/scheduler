require 'spec_helper'

describe Preference do
  describe 'that is valid' do
    subject { create(:preference) }

    it { should be_valid }
    its(:preference) { should_not be_nil }
    its(:section) { should_not be_nil }
    its(:user) { should_not be_nil }
  end

  describe 'is invalid when' do
    describe 'preference is <= 0' do
      subject { build(:preference, preference: 0) }
      it { should_not be_valid }
    end

    describe 'preference is > 1' do
      subject { build(:preference, preference: 3) }
      it { should_not be_valid }
    end
  end
end
