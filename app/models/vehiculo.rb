class Vehiculo < ApplicationRecord
  enum :estado, { activo: "activo", inactivo: "inactivo" }, default: :activo

  belongs_to :cliente
  has_many :ordenes_trabajo, dependent: :restrict_with_error

  validates :placa, presence: true, uniqueness: true
  validates :marca, :modelo, presence: true

  scope :activos, -> { where(estado: :activo) }

  def descripcion
    "#{marca} #{modelo} (#{placa})"
  end
end
