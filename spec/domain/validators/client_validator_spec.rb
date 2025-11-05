require 'rails_helper'
require_relative '../../../app/domain/validators/client_validator'

RSpec.describe Domain::Validators::ClientValidator do
  it 'validates a client with empty name' do
    client = Domain::Entities::Client.new(
              id: 1,
              email: 'juan.perez@example.com',
              identification: '123456789',
              type_identification: 'CC',
              address: 'Calle 123',
              state: 'active',
              created_at: Time.now,
              updated_at: Time.now
          )
    validator = described_class.new(client)
    validator.valid?
    expect(validator.valid?).to be_falsey
    expect(validator.errors).to include("El name es obligatorio")
  end

  it 'validates a client with short name' do
    client = Domain::Entities::Client.new(name: 'Jo', identification: '123456789', type_identification: 'CC', email: 'juan.perez@example.com')
    validator = described_class.new(client)
    validator.valid?
    expect(validator.errors).to include("El name debe tener al menos 3 caracteres")
  end

  it 'validates a client with long name' do
    long_name = 'J' * 201
    client = Domain::Entities::Client.new(name: long_name, identification: '123456789', type_identification: 'CC', email: 'juan.perez@example.com')
    validator = described_class.new(client)
    validator.valid?
    expect(validator.errors).to include("El name no puede exceder 200 caracteres")
  end

  it 'validates a client with empty identification' do
    client = Domain::Entities::Client.new(name: 'Juan', identification: '', type_identification: 'CC', email: 'juan.perez@example.com')
    validator = described_class.new(client)
    validator.valid?
    expect(validator.errors).to include("La identificación es obligatoria")
  end

  it 'validates a client with short identification' do
    client = Domain::Entities::Client.new(name: 'Juan', identification: '1234', type_identification: 'CC', email: 'juan.perez@example.com')
    validator = described_class.new(client)
    validator.valid?
    expect(validator.errors).to include("La identificación debe tener al menos 5 caracteres")
  end

  it 'validates a client with long identification' do
    long_id = '1' * 51
    client = Domain::Entities::Client.new(name: 'Juan', identification: long_id, type_identification: 'CC', email: 'juan.perez@example.com')
    validator = described_class.new(client)
    validator.valid?
    expect(validator.errors).to include("La identificación no puede exceder 50 caracteres")
  end

  it 'validates a client with invalid type_identification' do
    client = Domain::Entities::Client.new(name: 'Juan', identification: '123456789', type_identification: 'INVALID', email: 'juan.perez@example.com')
    validator = described_class.new(client)
    validator.valid?
    expect(validator.errors).to include("Tipo de identificación inválido. Debe ser: NIT, CC, CE, PASAPORTE")
  end

  it 'validates a client with empty email' do
    client = Domain::Entities::Client.new(name: 'Juan', identification: '123456789', type_identification: 'CC', email: '')
    validator = described_class.new(client)
    validator.valid?
    expect(validator.errors).to include("El email es obligatorio")
  end

  it 'validates a client with invalid email format' do
    client = Domain::Entities::Client.new(name: 'Juan', identification: '123456789', type_identification: 'CC', email: 'invalid-email')
    validator = described_class.new(client)
    validator.valid?
    expect(validator.errors).to include("El formato del email es inválido")
  end

  it 'validates a client with empty email' do
    client = Domain::Entities::Client.new(
              id: 1,
              name: 'Juan Perez',
              identification: '1234562789',
              type_identification: 'CC',
              address: 'Calle 123',
              state: 'active',
              created_at: Time.now,
              updated_at: Time.now
          )
    validator = described_class.new(client)
    validator.valid?
    expect(validator.valid?).to be_falsey
    expect(validator.errors).to include("El email es obligatorio")
  end

  it 'validates a client with invalid email format' do
    client = Domain::Entities::Client.new(
              id: 1,
              name: 'Juan Perez',
              email: 'invalid_email_format',
              identification: '1234562789',
              type_identification: 'CC',
              address: 'Calle 123',
              state: 'active',
              created_at: Time.now,
              updated_at: Time.now
          )
    validator = described_class.new(client)
    validator.valid?
    expect(validator.valid?).to be_falsey
    expect(validator.errors).to include("El formato del email es inválido")
  end

  it 'validates a client with invalid type_identification' do
    client = Domain::Entities::Client.new(
              id: 1,
              name: 'Juan Perez',
              email: 'juan.perez@example.com',
              identification: '1234562789',
              type_identification: 'CO',
              address: 'Calle 123',
              state: 'active',
              created_at: Time.now,
              updated_at: Time.now
          )
    validator = described_class.new(client)
    validator.valid?
    expect(validator.valid?).to be_falsey
    expect(validator.errors).to include("Tipo de identificación inválido. Debe ser: NIT, CC, CE, PASAPORTE")
  end

  it 'validates identification length' do
    client = Domain::Entities::Client.new(
              id: 1,
              name: 'Juan Perez',
              email: '',
              identification: '123',
              type_identification: 'CC',
              address: 'Calle 123', 
              state: 'active',
              created_at: Time.now,
              updated_at: Time.now
          )
    validator = described_class.new(client)
    validator.valid?
    expect(validator.valid?).to be_falsey
    expect(validator.errors).to include("La identificación debe tener al menos 5 caracteres")
  end

end