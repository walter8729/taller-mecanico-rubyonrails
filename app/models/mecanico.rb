class Mecanico < ApplicationRecord
  enum :estado, { activo: "activo", inactivo: "inactivo" }, default: :activo

  belongs_to :especialidad
  has_many :ordenes_mecanicos, dependent: :restrict_with_error
  has_many :ordenes_trabajo, through: :ordenes_mecanicos
  has_many :detalles_ordenes_servicios, dependent: :restrict_with_error

  validates :nombre, :apellido, presence: true

  scope :activos, -> { where(estado: :activo) }

  def nombre_completo
    [ nombre, apellido ].compact.join(" ")
  end
end
