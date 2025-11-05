module Domain
  module Validators
    class ClientValidator
      EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      TYPE_IDENTIFICATION_VALID = %w[NIT CC CE PASAPORTE]

      attr_reader :errors

      def initialize(client)
        @client = client
        @errors = []
      end

      def valid?
        validate_name
        validate_identification
        validate_type_identification
        validate_email

        @errors.empty?
      end

      private

      def validate_name
        if @client.name.nil? || @client.name.strip.empty?
          @errors << "El name es obligatorio"
        elsif @client.name.length < 3
          @errors << "El name debe tener al menos 3 caracteres"
        elsif @client.name.length > 200
          @errors << "El name no puede exceder 200 caracteres"
        end
      end

      def validate_identification
        if @client.identification.nil? || @client.identification.strip.empty?
          @errors << "La identificación es obligatoria"
        elsif @client.identification.length < 5
          @errors << "La identificación debe tener al menos 5 caracteres"
        elsif @client.identification.length > 50
          @errors << "La identificación no puede exceder 50 caracteres"
        end
      end

      def validate_type_identification
        unless TYPE_IDENTIFICATION_VALID.include?(@client.type_identification)
          @errors << "Tipo de identificación inválido. Debe ser: #{TYPE_IDENTIFICATION_VALID.join(', ')}"
        end
      end

      def validate_email
        if @client.email.nil? || @client.email.strip.empty?
          @errors << "El email es obligatorio"
        elsif !(@client.email =~ EMAIL_REGEX)
          @errors << "El formato del email es inválido"
        elsif @client.email.length > 100
          @errors << "El email no puede exceder 100 caracteres"
        end
      end
      
    end
  end
end