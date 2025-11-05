class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing

  private

  def handle_standard_error(exception)
    Rails.logger.error("Error: #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n"))

    render json: {
      message: 'Ha ocurrido un error interno',
      error: exception.message
    }, status: :internal_server_error
  end

  def handle_not_found(exception)
    render json: {
      message: 'Recurso no encontrado',
      error: exception.message
    }, status: :not_found
  end

  def handle_parameter_missing(exception)
    render json: {
      message: 'Parámetros requeridos faltantes',
      error: exception.message
    }, status: :bad_request
  end
end