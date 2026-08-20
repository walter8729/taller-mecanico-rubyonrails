require "test_helper"

class DetalleOrdenRepuestoTest < ActiveSupport::TestCase
  def orden_aprobada
    orden = ordenes_trabajo(:two)
    orden.transicionar_a!(:en_diagnostico)
    orden.diagnostico.validar!
    orden.transicionar_a!(:presupuestada)
    orden.presupuesto.aprobar!
    orden
  end

  test "descuenta stock al crear el detalle" do
    repuesto = repuestos(:two)
    stock_inicial = repuesto.stock
    orden = orden_aprobada

    detalle = DetalleOrdenRepuesto.create!(
      orden_trabajo: orden,
      repuesto: repuesto,
      cantidad: 2,
      precio_unitario: repuesto.precio
    )

    assert_equal stock_inicial - 2, repuesto.reload.stock
    assert_equal repuesto.precio, detalle.precio_unitario
  end

  test "no permite cantidad mayor al stock" do
    repuesto = repuestos(:two)
    orden = orden_aprobada

    detalle = DetalleOrdenRepuesto.new(
      orden_trabajo: orden,
      repuesto: repuesto,
      cantidad: repuesto.stock + 1
    )

    refute detalle.valid?
    assert detalle.errors[:repuesto].any?
  end

  test "no permite agregar repuestos a una orden en estado inicial" do
    detalle = DetalleOrdenRepuesto.new(
      orden_trabajo: ordenes_trabajo(:one),
      repuesto: repuestos(:one),
      cantidad: 1
    )

    refute detalle.valid?
    assert detalle.errors[:orden_trabajo].any?
  end
end
