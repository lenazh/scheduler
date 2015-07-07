require 'spec_helper'

describe Preference do
  let(:user) { create(:user) }
  let(:section) { create(:section) }

  describe "that is valid" do
    before(:each) do
      @preference = create(:preference, user: user, section: section)
      @preference.should be_valid
    end

    it "belongs to a Section" { expect(@preference.Section).not_to be_empty }
    it "belongs to a User" { expect(@preference.user).not_to be_empty }
    it "has a preference" { expect(@preference.preference).not_to be_empty }
  end  
end
