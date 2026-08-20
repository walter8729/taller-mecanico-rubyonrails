class Cliente < ApplicationRecord
  enum :estado, { activo: "activo", inactivo: "inactivo" }, default: :activo

  has_many :vehiculos, dependent: :restrict_with_error
  has_many :facturas, dependent: :restrict_with_error

  validates :nombre, presence: true
  validates :apellido, presence: true

  scope :activos, -> { where(estado: :activo) }

  def nombre_completo
    [ nombre, apellido ].compact.join(" ")
  end
end
