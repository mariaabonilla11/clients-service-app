require 'httparty'

module Infrastructure
  module Http
    class AuditServiceClient
      include HTTParty

      base_uri ENV.fetch('AUDITORIA_SERVICE_URL', 'http://localhost:3003')
      headers 'Content-Type' => 'application/json'
      default_timeout 5 # 5 segundos timeout

      def register_event(entity:, action:, entity_id:, metadata: {})
        body = {
          entity: entity,
          action: action,
          entity_id: entity_id,
          metadata: metadata,
          timestamp: Time.current.iso8601,
          service: 'clientes-service'
        }

        response = self.class.post('/api/v1/audit', body: body.to_json)

        if response.success?
          Rails.logger.info("Evento de auditoría registrado: #{entity}.#{action}")
          true
        else
          Rails.logger.error("Error al registrar auditoría: #{response.code} - #{response.body}")
          false
        end
      rescue HTTParty::Error, StandardError => e
        Rails.logger.error("Excepción al comunicar con servicio de auditoría: #{e.message}")
        false
      end

      def get_events_by_entity(entity_type, entity_id)
        response = self.class.get("/api/v1/audit/#{entity_type}/#{entity_id}")

        if response.success?
          JSON.parse(response.body)
        else
          Rails.logger.error("Error al obtener eventos: #{response.code}")
          []
        end
      rescue HTTParty::Error, StandardError => e
        Rails.logger.error("Excepción al obtener eventos: #{e.message}")
        []
      end
    end
  end
end