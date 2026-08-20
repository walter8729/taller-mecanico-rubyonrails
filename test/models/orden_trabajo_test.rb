require "test_helper"

class OrdenTrabajoTest < ActiveSupport::TestCase
  test "no permite transicionar a un estado no consecutivo" do
    orden = ordenes_trabajo(:one)

    refute orden.transicionar_a!(:aprobada)
    assert orden.errors[:estado].any?
  end

  test "no inicia reparacion sin presupuesto aprobado" do
    orden = ordenes_trabajo(:one)
    orden.transicionar_a!(:en_diagnostico)
    orden.build_diagnostico(fecha: Date.today, descripcion: "Diagnostico").save!
    orden.diagnostico.validar!
    orden.build_presupuesto(fecha: Date.today, monto_estimado: 1000).save!
    orden.presupuesto.update!(estado: :pendiente)

    refute orden.transicionar_a!(:en_reparacion)
    assert orden.errors[:estado].any?
  end

  test "ocupa la bahia al crearse" do
    bahia = bahias(:one)
    orden = OrdenTrabajo.create!(
      vehiculo: vehiculos(:one), bahia: bahia, fecha_ingreso: Date.today,
      hora_ingreso: "09:00:00", motivo_ingreso: "Prueba"
    )

    assert orden.recibida?
    assert_equal "ocupada", bahia.reload.estado
  end

  test "libera la bahia al entregarse" do
    orden = ordenes_trabajo(:one)
    orden.transicionar_a!(:en_diagnostico)
    orden.build_diagnostico(fecha: Date.today, descripcion: "Diagnostico").save!
    orden.diagnostico.validar!
    orden.build_presupuesto(fecha: Date.today, monto_estimado: 1000).save!
    orden.presupuesto.aprobar!
    orden.transicionar_a!(:en_reparacion)
    orden.finalizar!
    orden.transicionar_a!(:entregada)

    assert_equal "disponible", orden.bahia.reload.estado
  end

  test "no asigna bahia ocupada" do
    bahia_ocupada = Bahia.create!(numero: 77, estado: :ocupada)

    orden = OrdenTrabajo.new(
      vehiculo: vehiculos(:one), bahia: bahia_ocupada, fecha_ingreso: Date.today,
      hora_ingreso: "09:00:00", motivo_ingreso: "Prueba"
    )

    refute orden.valid?
    assert orden.errors[:bahia].any?
  end

  test "calcula totales de servicios y repuestos" do
    bahia = Bahia.create!(numero: 99)
    orden = OrdenTrabajo.create!(
      vehiculo: vehiculos(:one), bahia: bahia, fecha_ingreso: Date.today,
      hora_ingreso: "09:00:00", motivo_ingreso: "Prueba"
    )
    orden.update!(estado: :aprobada)
    orden.ordenes_mecanicos.create!(mecanico: mecanicos(:one))
    orden.detalles_ordenes_servicios.create!(servicio: servicios(:one), mecanico: mecanicos(:one), precio_aplicado: 100)
    orden.detalles_ordenes_repuestos.create!(repuesto: repuestos(:one), cantidad: 3, precio_unitario: 50)

    assert_equal 100, orden.total_servicios
    assert_equal 150, orden.total_repuestos
    assert_equal 250, orden.total
  end
end
