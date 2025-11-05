require 'rails_helper'
require_relative '../../../app/domain/entities/client'

RSpec.describe Domain::Entities::Client, type: :model do
  describe 'validations' do
    context 'with valid attributes' do
      it 'creates a client successfully' do
          client = Domain::Entities::Client.new(
              id: 1,
              name: 'Juan Perez',
              email: 'juan.perez@example.com',
              identification: '123456789',
              type_identification: 'CC',
              address: 'Calle 123',
              state: 'active',
              created_at: Time.now,
              updated_at: Time.now
          )
        expect(client.name).to eq('Juan Perez')
        expect(client.email).to eq('juan.perez@example.com')
        expect(client.identification).to eq('123456789')
        expect(client.type_identification).to eq('CC')
        expect(client.address).to eq('Calle 123')
      end
    end
  end
end