module UseCases
  module Clients
    class FindClient
      def initialize(client_repository:)
        @client_repository = client_repository
      end

      def execute(id)
        # 1. Buscar el client
        client = @client_repository.find_by_id(id)

        # 2. Validar si existe
        unless client
          return build_error_response(["client con ID #{id} no encontrado"])
        end

        # 3. Registrar auditoría de consulta
        # register_audit_event(client)

        # 4. Retornar resultado
        build_success_response(client)
      end

      private

      # def register_audit_event(client)
      #   @audit_client.register_event(
      #     entity: 'client',
      #     action: 'read',
      #     entity_id: client.id,
      #     metadata: {
      #       identificacion: client.identificacion
      #     }
      #   )
      # rescue => e
      #   Rails.logger.error("Error registrando auditoría: #{e.message}")
      # end

      def build_success_response(client)
        {
          success: true,
          data: client,
          errors: []
        }
      end

      def build_error_response(errors)
        {
          success: false,
          data: nil,
          errors: errors
        }
      end
    end
  end
end