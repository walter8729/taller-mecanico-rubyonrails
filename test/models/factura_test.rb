require "test_helper"

class FacturaTest < ActiveSupport::TestCase
  def orden_entregada
    orden = ordenes_trabajo(:two)
    orden.transicionar_a!(:en_diagnostico)
    orden.diagnostico.validar!
    orden.transicionar_a!(:presupuestada)
    orden.presupuesto.aprobar!
    orden.transicionar_a!(:en_reparacion)
    orden.finalizar!
    orden.transicionar_a!(:entregada)
    orden
  end

  test "calcula el monto total desde la orden" do
    orden = ordenes_trabajo(:two)
    orden.transicionar_a!(:en_diagnostico)
    orden.diagnostico.validar!
    orden.transicionar_a!(:presupuestada)
    orden.presupuesto.aprobar!
    orden.detalles_ordenes_servicios.create!(servicio: servicios(:two), mecanico: mecanicos(:two), precio_aplicado: 1000)
    orden.detalles_ordenes_repuestos.create!(repuesto: repuestos(:two), cantidad: 2, precio_unitario: 100)
    orden.transicionar_a!(:en_reparacion)
    orden.finalizar!
    orden.transicionar_a!(:entregada)

    factura = Factura.create!(orden_trabajo: orden, fecha: Date.today)

    assert_equal 1200, factura.monto_total
    assert_equal clientes(:two), factura.cliente
  end

  test "no permite facturar una orden sin finalizar" do
    factura = Factura.new(orden_trabajo: ordenes_trabajo(:one), fecha: Date.today)

    refute factura.valid?
    assert factura.errors[:orden_trabajo].any?
  end

  test "no permite eliminar una factura pagada" do
    factura = facturas(:one)
    assert factura.pagada?

    refute factura.destroy
    assert factura.errors[:base].any?
  end

  test "marca como pagada" do
    factura = facturas(:one)

    assert factura.pagar!
    assert factura.pagada?
  end
end
