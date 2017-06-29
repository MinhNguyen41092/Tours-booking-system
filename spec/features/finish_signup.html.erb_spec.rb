require 'rails_helper'

RSpec.describe "users/finish_signup", type: :feature do
  before(:each) do
    @user = Fabricate :user
    @user.confirmed_at = Time.now
    @user.save
    login_as @user, scope: :user
    visit finish_signup_path(@user)
  end

  describe "UI finish signup page" do
    it "should have title" do
      expect(page).to have_content I18n.t("users.add_email")
    end

    it "should have panel" do
      expect(page).to have_selector "//div[@class='panel panel-info pass-reset']"
      expect(page).to have_selector "//div[@class='panel-heading']"
    end

    it "should have form" do
      expect(page).to have_field "user[email]"
      expect(page).to have_content I18n.t("users.no_spam")
      expect(page).to have_selector "input[type=submit][value= #{I18n.t("users.continue")}]"
    end

    it "should be a clickable button" do
      click_button I18n.t("users.continue")
    end
  end
end
