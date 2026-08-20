class Diagnostico < ApplicationRecord
  enum :estado, { registrado: "registrado", validado: "validado" }, default: :registrado

  belongs_to :orden_trabajo

  validates :fecha, :descripcion, presence: true
  validates :orden_trabajo_id, uniqueness: true

  validate :orden_en_diagnostico_o_posterior, on: :create
  validate :no_editar_validado, on: :update

  def validar!
    update!(estado: :validado)
  end

  private
    def orden_en_diagnostico_o_posterior
      return if orden_trabajo.nil? || !orden_trabajo.recibida?
      errors.add(:orden_trabajo, "debe estar en diagnóstico o posterior para registrar un diagnóstico")
    end

    def no_editar_validado
      return unless estado_was == "validado"
      errors.add(:estado, "no se puede modificar un diagnóstico validado")
    end
end
