class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_signup_complete, except: [:index, :show]

  def verify_admin
    if user_signed_in?
      if !current_user.is_admin
        flash[:danger] = t "users.not_admin"
        redirect_to root_path
      end
    else
      flash[:danger] = t "users.pls_log_in"
      redirect_to root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email,
      :full_name, :password, :password_confirmation, :remember_me,
      :avatar, :avatar_cache, :remove_avatar) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email,
      :full_name, :password, :password_confirmation, :current_password,
      :avatar, :avatar_cache, :remove_avatar) }
  end

  def ensure_signup_complete
    return if action_name == t("users.finish_signup")
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path current_user
    end
  end
end
