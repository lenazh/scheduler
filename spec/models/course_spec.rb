require 'spec_helper'

describe Course do
  let(:user) { create(:user) }

  describe 'that is valid should have' do
    subject { create(:course, user: user) }

    it { should be_valid }
    its(:name) { should_not be_empty }
    its(:user) { should_not be_nil }

    its(:sections) { should respond_to :[] }
    its(:gsis) { should respond_to :[] }
  end

  describe 'is invalid if the name is empty' do
    subject { build(:course, user: user, name: '  ') }
    it { should_not be_valid }
  end
end
