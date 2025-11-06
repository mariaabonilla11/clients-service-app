require_dependency Rails.root.join('app/infrastructure/repositories/oracle_client_repository').to_s
require_dependency Rails.root.join('app/infrastructure/http/audit_service').to_s
module UseCases
  module Clients
    class CreateClient
      def initialize(repository: Infrastructure::Repositories::OracleClientRepository.new)
        @repository = repository
        @audit_client = Infrastructure::Http::AuditService.new
      end

      def execute(params)
        client = Domain::Entities::Client.new(
          name: params[:name],
          email: params[:email],
          identification: params[:identification],
          type_identification: params[:type_identification],
          state: params[:state],
          address: params[:address]
        )
        result = @repository.create(client)

        # Registrar auditoría con el resultado que tiene el ID asignado
        register_audit_event(result)
        return result
      end

      private

      def register_audit_event(client)
        @audit_client.create_audit(
          entity: 'client',
          action: 'create',
          entity_id: client.id.to_s,
          metadata: {
            client_id: client.id,
            name: client.name,
            email: client.email,
            identification: client.identification,
            type_identification: client.type_identification
          }.to_json,
          timestamp: Time.now.utc.iso8601,
          service: 'clients-service'
        )
      rescue => e
        Rails.logger.error("Error registrando auditoría: #{e.message}")
      end
    end
  end
end