require "test_helper"

class PresupuestoTest < ActiveSupport::TestCase
  test "aprobarlo lleva la orden a aprobada" do
    orden = ordenes_trabajo(:one)
    orden.update!(estado: :en_diagnostico)
    orden.build_diagnostico(fecha: Date.today, descripcion: "Diagnostico").save!
    orden.diagnostico.validar!
    orden.build_presupuesto(fecha: Date.today, monto_estimado: 1000).save!
    presupuesto = orden.presupuesto

    assert presupuesto.aprobar!
    assert presupuesto.aprobado?
    assert orden.reload.aprobada?
  end

  test "rechazarlo cancela la orden" do
    orden = ordenes_trabajo(:one)
    orden.update!(estado: :en_diagnostico)
    orden.build_diagnostico(fecha: Date.today, descripcion: "Diagnostico").save!
    orden.diagnostico.validar!
    orden.build_presupuesto(fecha: Date.today, monto_estimado: 1000).save!
    presupuesto = orden.presupuesto

    assert presupuesto.rechazar!
    assert presupuesto.rechazado?
    assert orden.reload.cancelada?
  end

  test "requiere diagnostico para generarse" do
    presupuesto = Presupuesto.new(orden_trabajo: ordenes_trabajo(:one), fecha: Date.today)

    refute presupuesto.valid?
    assert presupuesto.errors[:orden_trabajo].any?
  end
end
