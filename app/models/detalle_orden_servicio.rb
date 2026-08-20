class DetalleOrdenServicio < ApplicationRecord
  belongs_to :orden_trabajo
  belongs_to :servicio
  belongs_to :mecanico

  validates :precio_aplicado, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :orden_en_estado_permitido
  validate :mecanico_asignado_a_orden

  before_validation :aplicar_precio_base

  private
    def aplicar_precio_base
      self.precio_aplicado ||= servicio&.precio_base
    end

    def orden_en_estado_permitido
      return if orden_trabajo.nil? || orden_trabajo.aprobada? || orden_trabajo.en_reparacion?
      errors.add(:orden_trabajo, "solo permite agregar servicios en estado Aprobada o En reparación")
    end

    def mecanico_asignado_a_orden
      return if orden_trabajo.nil? || orden_trabajo.mecanicos.include?(mecanico)
      errors.add(:mecanico, "debe estar asignado a la orden de trabajo")
    end
end
