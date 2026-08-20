class Repuesto < ApplicationRecord
  enum :estado, { activo: "activo", inactivo: "inactivo" }, default: :activo

  belongs_to :proveedor
  has_many :detalles_ordenes_repuestos, dependent: :restrict_with_error

  validates :nombre, presence: true
  validates :precio, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :activos, -> { where(estado: :activo) }
  scope :con_stock, -> { activos.where("stock > 0") }

  def stock_disponible?(cantidad = 1)
    stock >= cantidad
  end
end
