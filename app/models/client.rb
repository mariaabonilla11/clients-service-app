class Client < ApplicationRecord

  # Validaciones a nivel de ActiveRecord (seguridad adicional)
  validates :name, presence: true, length: { minimum: 3, maximum: 200 }
  validates :identification, presence: true, uniqueness: true, length: { minimum: 5, maximum: 50 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: 100 }
  validates :type_identification, inclusion: { in: %w[NIT CC CE PASAPORTE] }

  enum state: {
    active: 1,
    inactive: 0,
    pending: 2,
    suspended: 3
  }

end