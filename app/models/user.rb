class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :rol, { admin: "admin", recepcionista: "recepcionista", mecanico: "mecanico" }

  validates :rol, inclusion: { in: rols.keys }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
