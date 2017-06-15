require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = Fabricate :user
  end

  describe "relationships" do
    it {should have_one(:identity).dependent(:destroy)}
    it {should have_one(:cart)}
    it {should have_many(:comments)}
    it {should have_many(:orders)}
    it {should have_many(:reviews)}
    it {should have_many(:financial_reports)}
  end

  describe "validations" do
    it "should not have username of other people's email" do
      user2 = User.new username: "dinhminh@example.com"
      expect(user2).not_to be_valid
    end

    it "should not allow TEMP_EMAIL_REGEX to email when update" do
      expect(@user.update(email: "change@me-minh")).to be false
    end

    it {should validate_presence_of(:username)}
    it {should validate_uniqueness_of(:username).case_insensitive}
  end

  describe "login by username" do
    it "can find user by usename" do
      expect(User.find_for_database_authentication({login: @user.username})).to eq @user
    end

    it "can find user by email" do
      expect(User.find_for_database_authentication({login: @user.email})).to eq @user
    end
  end

  it "should have email verified" do
    @user.email = "change@me-minh"
    expect(@user.email_verified?).to be false
  end
end
