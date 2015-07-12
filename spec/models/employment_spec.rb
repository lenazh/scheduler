require 'spec_helper'

describe Employment do
  let(:gsi) { create(:user) }
  let(:course) { create(:course) }

  describe "that is valid" do
    subject { create(:employment, gsi: gsi, course: course) }

    it { should be_valid }
    its (:course) { should_not be_nil }
    its (:gsi) { should_not be_nil }
    its (:hours_per_week) { should_not be_nil }
  end  
end
