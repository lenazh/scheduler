require 'spec_helper'

describe User do
  describe "that is valid" do
    before(:each) do
      @user = create(:user)
      @user.should be_valid
    end

    it "has a name" { expect(@user.name).not_to be_empty }
    it "has auth token" { expect(@user.auth_token).not_to be_empty }
    it "has an email" { expect(@user.email).not_to be_empty }

    it "has many Sections to teach" { expect(@user.sections).to be_kind_of(Array) }
    it "has many Courses to teach" { expect(@user.courses).to be_kind_of(Array) }

  end  

  describe "is invalid if" do

    after(:each) { @user.should_not be_valid }

    it "name is empty" { @user = build(:user, name: " ") }
    it "auth_token is empty" { pending "Authentication is not implemented" }
    it "email is empty" { @user = build(:user, email: " ") }
    it "email has a wrong format" { @user = build(:user, email: "ghavcn") }

  end

end
