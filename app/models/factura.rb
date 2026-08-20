class Factura < ApplicationRecord
  enum :estado, { pendiente: "pendiente", pagada: "pagada" }, default: :pendiente

  belongs_to :cliente
  belongs_to :orden_trabajo

  validates :fecha, presence: true
  validates :monto_total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :orden_trabajo_id, uniqueness: true

  validate :orden_finalizada_o_entregada, on: :create

  before_destroy :no_eliminar_pagada

  before_validation :asignar_cliente
  before_validation :calcular_monto_total

  def pagar!
    update!(estado: :pagada)
  end

  private
    def asignar_cliente
      self.cliente ||= orden_trabajo&.vehiculo&.cliente
    end

    def calcular_monto_total
      return if orden_trabajo.nil?
      self.monto_total = orden_trabajo.total_servicios + orden_trabajo.total_repuestos
    end

    def orden_finalizada_o_entregada
      return if orden_trabajo.nil? || orden_trabajo.finalizada? || orden_trabajo.entregada?
      errors.add(:orden_trabajo, "debe estar finalizada o entregada para facturar")
    end

    def no_eliminar_pagada
      if pagada?
        errors.add(:base, "no se puede eliminar una factura pagada")
        throw :abort
      end
    end
end
