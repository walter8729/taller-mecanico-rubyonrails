require "test_helper"

class DetalleOrdenServicioTest < ActiveSupport::TestCase
  def orden_aprobada
    orden = ordenes_trabajo(:two)
    orden.transicionar_a!(:en_diagnostico)
    orden.diagnostico.validar!
    orden.transicionar_a!(:presupuestada)
    orden.presupuesto.aprobar!
    orden
  end

  test "aplica el precio base del servicio" do
    orden = orden_aprobada

    detalle = DetalleOrdenServicio.create!(
      orden_trabajo: orden,
      servicio: servicios(:two),
      mecanico: mecanicos(:two)
    )

    assert_equal servicios(:two).precio_base, detalle.precio_aplicado
  end

  test "no permite agregar servicios en orden recibida" do
    detalle = DetalleOrdenServicio.new(
      orden_trabajo: ordenes_trabajo(:one),
      servicio: servicios(:one),
      mecanico: mecanicos(:one)
    )

    refute detalle.valid?
    assert detalle.errors[:orden_trabajo].any?
  end

  test "no permite un mecanico no asignado a la orden" do
    orden = orden_aprobada

    detalle = DetalleOrdenServicio.new(
      orden_trabajo: orden,
      servicio: servicios(:two),
      mecanico: mecanicos(:one)
    )

    refute detalle.valid?
    assert detalle.errors[:mecanico].any?
  end
end
