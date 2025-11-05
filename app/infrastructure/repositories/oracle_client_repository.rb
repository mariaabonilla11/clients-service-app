require_dependency Rails.root.join('app/domain/repositories/client_repository').to_s
require_dependency Rails.root.join('app/domain/entities/client').to_s
module Infrastructure
  module Repositories
    class OracleClientRepository < Domain::Repositories::ClientRepository
      def create(client)
        result = ::Client.create(name: client.name, email: client.email, identification: client.identification, type_identification: client.type_identification, address: client.address)
        return result if result.persisted?
        { errors: result.errors.full_messages }
      end

      def find_by_id(id)
        record = ::Client.find_by(id: id)
        return nil unless record

        Domain::Entities::Client.new(
          id: record.id,
          name: record.name,
          email: record.email,
          identification: record.identification,
          type_identification: record.type_identification,
          address: record.address,
          state: record.state
        )
      end
    end
  end
end