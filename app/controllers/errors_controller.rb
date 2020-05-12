class ErrorsController < ApplicationController
  skip_before_action :authenticate_admin

  def not_found
    logger.info "Not found: #{request.fullpath}"
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: 404 }
      format.all  { head 404 }
    end
  end
end
