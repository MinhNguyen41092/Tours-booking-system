class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create]
  before_action :authenticate_user!
  before_action :verify_admin, only: :index

  def index
    @users = User.all.page(params[:page])
      .per Settings.items_per_pages
  end

  def show
    @reviews = @user.reviews.newest.page(params[:page])
      .per Settings.items_per_pages
  end

  def update
    if @user.update user_params
      redirect_to @user, notice: t("users.update_success")
    else
      render :edit
    end
  end

  def finish_signup
    if request.patch? && params[:user]
      if @user.update user_params
        sign_in @user, bypass: true
        redirect_to @user, notice: t("users.update_success")
      else
        flash[:danger] = t "users.update_failed"
      end
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.deleted"
    else
      flash[:danger] = t "users.delete_failed"
    end
    redirect_to :back
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "users.no_user"
    redirect_to root_path
  end

  def user_params
    accessibles = [:username, :email, :avatar, :full_name]
    accessibles << [:password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit accessibles
  end
end