require_relative '../../../use_cases/clients/create_client'
require_relative '../../../use_cases/clients/find_client'
require_dependency Rails.root.join('app/infrastructure/repositories/oracle_client_repository').to_s
class Api::V1::ClientsController < ApplicationController
  def index
    clients = ::Client.where(state: "active")
    if clients.any?
      render json: { message: "Clientes activos encontrados", clients: clients }, status: :ok
    else
      render json: { message: "No hay clientes activos registrados" }, status: :not_found
    end
  end

  def create
    result = ::UseCases::Clients::CreateClient.new.execute(client_params)
    if result.is_a?(Hash) && result[:errors]
      render json: { message: 'Errores de validación', errors: result[:errors] }, status: :unprocessable_entity
    else
      render json: { message: 'Cliente creado exitosamente', client: result }, status: :created
    end
  end

  def show
    client_id = params[:id]
    client_repository = Infrastructure::Repositories::OracleClientRepository.new
    # audit_client = Infrastructure::Http::AuditServiceClient.new
    result = ::UseCases::Clients::FindClient.new(client_repository: client_repository).execute(client_id)

    if result[:success]
      render json: { message: "Cliente encontrado exitosamente", client: result}, status: :ok
    else
      render json: { message: "Cliente no encontrado", errors: result[:errors] }, status: :not_found
    end
  end
  

  private

  def client_params
    params.require(:client).permit(:name, :email, :identification, :type_identification, :address)
  end
end