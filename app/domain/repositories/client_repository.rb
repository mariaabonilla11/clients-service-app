module Domain
  module Repositories
    class ClientRepository
      def create(client)
        raise NotImplementedError
      end

      def find_by_id(id)
        raise NotImplementedError
      end
    end
  end
end