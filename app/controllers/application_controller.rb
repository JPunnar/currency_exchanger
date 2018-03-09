# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.present?
      redirect_to root_url, notice: exception.message
    else
      redirect_to new_user_session_url, notice: exception.message
    end
  end
end
