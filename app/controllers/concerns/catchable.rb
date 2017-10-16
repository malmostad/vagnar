module Catchable
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |exception|
      logger.info exception.message.to_s
      redirect_to root_path, alert: 'Behörighet saknas'
    end

    rescue_from ActionController::InvalidAuthenticityToken do |exception|
      logger.debug { exception.message.to_s }
      logger.info "ActionController::InvalidAuthenticityToken (maybe session expired) for the user from #{client_ip}"
      redirect_to logout_path, notice: 'Du är utloggad'
    end

    rescue_from ActiveRecord::RecordNotFound,
                ActionController::RoutingError,
                ActionController::UnknownController,
                ActionController::MethodNotAllowed do |exception|
      logger.info exception.message.to_s
      logger.info "Not found: #{request.fullpath}"
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404", layout: false, status: 404 }
        format.all  { render nothing: true, status: 404 }
      end
    end
  end
end
