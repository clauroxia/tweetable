module Api
  class ApiController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    include ActionController::HttpAuthentication::Token::ControllerMethods
    before_action :authorize_token, except: %i[index show]
    
    def not_found(error)
      render json: { errors: error.message }, status: :not_found
    end

    def current_user
      @current_user ||= authenticate_token
    end

    def authorize_token
      authenticate_token || not_authorized
    end

    def authenticate_token
      authenticate_with_http_token do |token, _options|
        User.find_by(token: token)
      end
    end

    def not_authorized
      render json: { errors: "Invalid token, please log in" }, status: :unauthorized
    end
    

  end
end
