class DetalleOrdenRepuesto < ApplicationRecord
  belongs_to :orden_trabajo
  belongs_to :repuesto

  validates :cantidad, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :precio_unitario, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :repuesto_activo
  validate :stock_suficiente
  validate :orden_en_estado_permitido

  before_validation :aplicar_precio_repuesto
  after_create :descontar_stock

  private
    def aplicar_precio_repuesto
      self.precio_unitario ||= repuesto&.precio
    end

    def repuesto_activo
      errors.add(:repuesto, "debe estar activo") if repuesto && !repuesto.activo?
    end

    def stock_suficiente
      return if repuesto.nil? || repuesto.stock_disponible?(cantidad)
      errors.add(:repuesto, "no tiene stock suficiente")
    end

    def orden_en_estado_permitido
      return if orden_trabajo.nil? || orden_trabajo.aprobada? || orden_trabajo.en_reparacion?
      errors.add(:orden_trabajo, "solo permite agregar repuestos en estado Aprobada o En reparación")
    end

    def descontar_stock
      repuesto.decrement!(:stock, cantidad)
    end
end
