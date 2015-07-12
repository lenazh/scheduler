require 'spec_helper'

describe User do
  describe "that is valid" do
    subject { create(:user, auth_token: "none") }

    it { should be_valid }
    its (:name) { should_not be_empty }
    its (:email) { should_not be_empty }
    its (:auth_token) { should_not be_empty }

    its (:sections) { should respond_to :[] }
    its (:courses) { should respond_to :[] }

  end  

  describe "is invalid if" do
    describe "name is empty" do
      subject { build(:user, name: " ") }
      it {should_not be_valid}
    end

    describe "email is empty" do
      subject { build(:user, email: " ") }
      it {should_not be_valid}
    end

    describe "email has invalid format" do
      subject { build(:user, email: "ghavcn") }
      it {should_not be_valid}
    end

    describe "auth_token is empty" do
      pending "Authentication is not implemented" 
    end
  end

end
