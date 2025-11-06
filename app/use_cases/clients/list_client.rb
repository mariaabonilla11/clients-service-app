module UseCases
  module Client
    class Listclient
      def initialize(client_repository:, audit_client:)
        @client_repository = client_repository
        @audit_client = audit_client
      end

      def execute(filters = {})
        # 1. Obtener todos los client
        client = @client_repository.all

        # 2. Aplicar filtros si existen
        client = apply_filters(client, filters)

        # 3. Registrar auditoría de consulta masiva
        register_audit_event(client.count)

        # 4. Retornar resultado
        build_success_response(client)
      end

      private

      def apply_filters(client, filters)
        filtered = client

        # Filtrar por estado si se proporciona
        if filters[:state].present?
          filtered = filtered.select { |c| c.state == filters[:state] }
        end

        filtered
      end

      def register_audit_event(client_count)
        @audit_client.create_audit(
          entity: 'client',
          action: 'list',
          entity_id: 'bulk_list', # Operación masiva, no un cliente específico
          metadata: {
            result_count: client_count,
            operation: 'list_all_clients'
          }.to_json,
          timestamp: Time.now.utc.iso8601,
          service: 'clients-service'
        )
      rescue => e
        Rails.logger.error("Error registrando auditoría: #{e.message}")
      end

      def build_success_response(client)
        {
          success: true,
          data: client,
          errors: []
        }
      end
    end
  end
end