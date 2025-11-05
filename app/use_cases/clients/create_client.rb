require_dependency Rails.root.join('app/infrastructure/repositories/oracle_client_repository').to_s
module UseCases
  module Clients
    class CreateClient
      def initialize(repository: Infrastructure::Repositories::OracleClientRepository.new)
        @repository = repository
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
        return result
      end
    end
  end
end