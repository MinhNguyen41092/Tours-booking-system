require 'rails_helper'

RSpec.describe "users/show", type: :feature do
  before(:each) do
    @user = Fabricate :user
    @user.confirmed_at = Time.now
    @user.save
    login_as @user, scope: :user
    visit user_path @user
  end

  describe "UI show page" do
    it "should display avatar" do
      expect(page).to have_selector "//img[@src='#{@user.avatar.avatar}']"
    end

    it "should display username" do
      expect(page).to have_content @user.username
    end

    it "should display full_name" do
      expect(page).to have_content @user.full_name
    end

    it "should display email" do
      expect(page).to have_content @user.email
    end
  end
end
