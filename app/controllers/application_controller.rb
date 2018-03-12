# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.present?
      redirect_to root_url, notice: exception.message
    else
      redirect_to new_user_session_url, notice: exception.message
    end
  end

  protected

    def configure_permitted_parameters
      added_attrs = [:username, :email, :password, :password_confirmation]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    end
end
