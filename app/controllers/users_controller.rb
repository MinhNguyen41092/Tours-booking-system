class UsersController < ApplicationController
  before_action :load_user, except: [:new, :create]
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
  end

  def update
    if @user.update user_params
      sign_in(@user == current_user ? @user : current_user, bypass: true)
      redirect_to @user, notice: t("users.update_success")
    else
      render :edit
    end
  end

  def finish_signup
    if request.patch? && params[:user]
      if @user.update user_params
        sign_in(@user, bypass: true)
        redirect_to @user, notice: t("users.update_success")
      else
        flash[:danger] = t "users.update_failed"
      end
    end
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "users.no_user"
    redirect_to root_path
  end

  def user_params
    accessibles = [:username, :email]
    accessibles << [:password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit accessibles
  end
end
