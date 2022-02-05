class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!, except: %i[index show]
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username name avatar])
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end
end
