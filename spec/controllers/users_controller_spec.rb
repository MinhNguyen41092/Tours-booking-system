require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "callbacks" do
    it {should use_before_action(:authenticate_user!)}
    it {should use_before_action(:load_user)}
    it {should use_before_action(:verify_admin)}
  end

  before(:each) do
    @user = Fabricate :user
    @user.confirmed_at = Time.zone.now
    @user.save
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
    @request.env["HTTP_REFERER"] = "back"
  end

  describe "get request" do
    context "success" do
      it "should have a current user" do
        expect(subject.current_user).to_not eq nil
      end

      it "is a successful index request" do
        get :index
        expect(response).to have_http_status :success
        expect(response).to render_template :index
      end

      it "is a successful get show request" do
        get :show, params: {id: @user.id}
        expect(response).to have_http_status :success
        expect(response).to render_template :show
      end

      it "is a successful finish_signup request" do
        get :finish_signup, params: {id: @user.id}
        expect(response).to have_http_status :success
        expect(response).to render_template :finish_signup
      end
    end

    context "failed" do
      before(:each) do
        @user1  = Fabricate :user, username: "minh1", email: "minh1@exp", is_admin: false
      end

      it "should not be able to access index page if not admin" do
        @user1.confirmed_at = Time.zone.now
        @user1.save
        sign_in @user1
        get :index
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to match I18n.t("users.not_admin")
      end

      it "should not be able to access others finish signup page" do
        get :finish_signup, params: {id: @user1.id}
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to match I18n.t("users.not_correct_user")
      end
    end
  end

  describe "destroy" do
    it "should delete user" do
      expect{delete :destroy, id: @user.id}.to change User, :count
      expect(flash[:success]).to match I18n.t("users.deleted")
      expect(response).to redirect_to "back"
    end
  end

  describe "update finish_signup" do
    it "should update user" do
      expect {
        patch :finish_signup, id: @user, user: {email: "changed.mail@exp"}
        @user.reload
      }.to change(@user, :email).to("changed.mail@exp")
      expect(response).to redirect_to user_path(@user)
    end

    it "should not update if invalid params" do
      expect {
        patch :finish_signup, id: @user, user: {email: ""}
        @user.reload
      }.to_not change(@user, :email)
      expect(response).to render_template :finish_signup
    end
  end
end
