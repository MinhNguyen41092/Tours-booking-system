class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_signup_complete, except: [:index, :show]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :full_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :full_name])
  end

  def ensure_signup_complete
    return if action_name == t("users.finish_signup")
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path current_user
    end
  end
end
