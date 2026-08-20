class Proveedor < ApplicationRecord
  enum :estado, { activo: "activo", inactivo: "inactivo" }, default: :activo

  has_many :repuestos, dependent: :restrict_with_error

  validates :nombre, presence: true, uniqueness: true

  scope :activos, -> { where(estado: :activo) }
end
