require 'spec_helper'

describe Preference do
  let(:user) { create(:user) }
  let(:section) { create(:section) }

  describe "that is valid" do
    subject { create(:preference, user: user, section: section) }

    it { should be_valid }
    its (:preference) { should_not be_nil }
    its (:section) { should_not be_nil }
    its (:user) { should_not be_nil }
  end  
end
