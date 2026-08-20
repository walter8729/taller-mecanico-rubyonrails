class Presupuesto < ApplicationRecord
  enum :estado, { pendiente: "pendiente", aprobado: "aprobado", rechazado: "rechazado" }, default: :pendiente

  belongs_to :orden_trabajo

  validates :fecha, presence: true
  validates :monto_estimado, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :orden_trabajo_id, uniqueness: true

  validate :orden_con_diagnostico, on: :create

  after_create :marcar_orden_presupuestada

  def aprobar!
    transaction do
      update!(estado: :aprobado)
      orden_trabajo.transicionar_a!(:aprobada)
    end
  end

  def rechazar!
    transaction do
      update!(estado: :rechazado)
      orden_trabajo.transicionar_a!(:cancelada)
    end
  end

  private
    def orden_con_diagnostico
      return if orden_trabajo.nil? || orden_trabajo.diagnostico.present?
      errors.add(:orden_trabajo, "debe tener un diagnóstico para generar el presupuesto")
    end

    def marcar_orden_presupuestada
      orden_trabajo.transicionar_a!(:presupuestada)
    end
end
