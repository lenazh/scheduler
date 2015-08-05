require 'spec_helper'

describe User do
  describe 'that is valid' do
    subject { create(:user) }

    it { should be_valid }
    its(:name) { should_not be_empty }
    its(:email) { should_not be_empty }

    its(:sections) { should respond_to :[] }
    its(:courses) { should respond_to :[] }
  end

  let(:course1) { create(:course) }
  let(:course2) { create(:course) }
  let(:course) { course1 }
  let(:owner) { course.user }
  let(:user) { create(:user) }
  let(:gsi) do
    gsi = create(:user)
    course.gsis << gsi
    course.save!
    gsi
  end

  describe 'is invalid if' do
    describe 'name is empty' do
      subject { build(:user, name: ' ') }
      it { should_not be_valid }
    end

    describe 'email is empty' do
      subject { build(:user, email: ' ') }
      it { should_not be_valid }
    end

    describe 'email is taken' do
      before(:each) do
        FactoryGirl.create(:user, email: 'cat@gmail.com')
      end
      subject { build(:user, email: 'cat@gmail.com') }
      it { should_not be_valid }
    end

    describe 'email has invalid format' do
      subject { build(:user, email: 'ghavcn') }
      it { should_not be_valid }
    end
  end

  describe 'signed_in_before' do
    let(:user) { create(:user) }
    it 'returns true if sign_in_count > 0' do
      user.sign_in_count = 3
      user.save!
      expect(user.signed_in_before).to be true
    end

    it 'returns false if sign_in_count = 0' do
      user.sign_in_count = 0
      user.save!
      expect(user.signed_in_before).to be false
    end
  end

  describe 'appointments_count' do
    it 'returns 0 if the person has no appointments' do
      expect(user.appointments_count).to eq 0
    end

    it 'returns 1 if the person has 1 appointment' do
      user.courses_to_teach << course1
      user.save!
      expect(user.appointments_count).to eq 1
    end

    it 'returns 2 if the person has 2 appointments' do
      user.courses_to_teach << course1
      user.courses_to_teach << course2
      user.save!
      expect(user.appointments_count).to eq 2
    end
  end

  describe 'teaching_course?(course)' do
    it 'returns true if the use teaches the course' do
      expect(gsi.teaching_course?(course)).to be true
    end

    it "returns false if the user doesn't teach the course" do
      expect(user.teaching_course?(course)).to be false
    end

    it 'returns false if the course is nil' do
      expect(gsi.teaching_course?(nil)).to be false
    end
  end

  describe 'owns_course?(course)' do
    it 'returns true if the use teaches the course' do
      expect(owner.owns_course?(course)).to be true
    end

    it "returns false if the user doesn't teach the course" do
      expect(gsi.owns_course?(course)).to be false
    end

    it 'returns false if the course is nil' do
      expect(owner.owns_course?(nil)).to be false
    end
  end
end
