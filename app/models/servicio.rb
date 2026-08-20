class Servicio < ApplicationRecord
  enum :estado, { activo: "activo", inactivo: "inactivo" }, default: :activo

  has_many :detalles_ordenes_servicios, dependent: :restrict_with_error

  validates :nombre, presence: true, uniqueness: true
  validates :precio_base, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :activos, -> { where(estado: :activo) }
end
