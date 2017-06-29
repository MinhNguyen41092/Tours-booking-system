require 'rails_helper'

RSpec.describe "users/index", type: :feature do
  before(:each) do
    @user = Fabricate :user
    @user.confirmed_at = Time.now
    @user.save
    @user1 = Fabricate :user, username: "minh1", email: "minh1@exp", avatar: "minh1.jpg"
    @user1.confirmed_at = Time.now
    @user1.save
    @user2 = Fabricate :user, username: "minh2", email: "minh2@exp", avatar: "minh2.jpg"
    @user2.confirmed_at = Time.now
    @user2.save
    login_as @user, scope: :user
    visit users_path
  end

  describe "UI index page" do
    it "should display user info" do
      expect(page).to have_link @user.username, href: user_path(@user)
      expect(page).to have_link @user.email, href: user_path(@user)
      expect(page).to have_selector "//img[@src='#{@user.avatar.avatar}']"
    end

    it "should display user 1" do
      expect(page).to have_link @user1.username, href: user_path(@user1)
      expect(page).to have_link @user1.email, href: user_path(@user1)
      expect(page).to have_selector "//img[@src='#{@user1.avatar.avatar}']"
    end

    it "should display user 2" do
      expect(page).to have_link @user2.username, href: user_path(@user2)
      expect(page).to have_link @user2.email, href: user_path(@user2)
      expect(page).to have_selector "//img[@src='#{@user2.avatar.avatar}']"
    end

    it "should display icon trash" do
      expect(page).to have_xpath "//span[@class= 'glyphicon glyphicon-trash icon-trash']"
    end

    it "can delete user 1" do
      first(:link, href: user_path(@user1)).click
      expect(page).to have_content I18n.t("users.deleted")
    end

    it "can delete user 2" do
      first(:link, href: user_path(@user2)).click
      expect(page).to have_content I18n.t("users.deleted")
    end
  end
end
