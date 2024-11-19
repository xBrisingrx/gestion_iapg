class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate

  helper_method :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def authenticate
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      else
        redirect_to sign_in_path
      end
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end

    def current_user
      if Current.user
        @current_user ||= User.find_by_id(Current.user.id)
      else
        @current_user = nil
      end
    end

    def user_not_authorized
      redirect_to unauthorized_path
    end
end
