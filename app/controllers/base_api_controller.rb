class BaseApiController < ApplicationController
  before_action :set_default_response_format

  rescue_from ActionController::ParameterMissing, Errors::ValidationException, with: :log_server_error

  def set_default_response_format
    request.format = :json
  end

  def set_timezone
    Time.zone = 'UTC'
  end

  private

  def log_server_error(ex)
    Airbrake.notify(ex)
    render json: { error: ex.message }, status: 500
  end

end
