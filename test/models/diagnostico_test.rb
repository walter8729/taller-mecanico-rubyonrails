require "test_helper"

class DiagnosticoTest < ActiveSupport::TestCase
  test "no permite editar un diagnostico validado" do
    diagnostico = diagnosticos(:one)
    diagnostico.update!(estado: :validado)

    refute diagnostico.update(descripcion: "Cambio")
    assert diagnostico.errors[:estado].any?
  end

  test "no permite registrar diagnostico en orden recibida" do
    diagnostico = Diagnostico.new(
      orden_trabajo: ordenes_trabajo(:one),
      fecha: Date.today,
      descripcion: "Nuevo diagnostico"
    )

    refute diagnostico.valid?
    assert diagnostico.errors[:orden_trabajo].any?
  end
end
