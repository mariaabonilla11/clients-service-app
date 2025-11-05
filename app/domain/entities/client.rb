module Domain
  module Entities
    class Client
      attr_accessor :id, :name, :email, :identification, :type_identification, :address

      def initialize(id: nil, name: nil, email: nil, identification: nil, type_identification: nil, address: nil, state: nil, created_at: nil, updated_at: nil)
        @id = id
        @name = name
        @email = email
        @identification = identification
        @type_identification = type_identification
        @address = address
        @state = state
        @created_at = created_at
        @updated_at = updated_at
      end
    end
  end
end
