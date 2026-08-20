require "test_helper"

class DetallesOrdenesServiciosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @orden_trabajo = ordenes_trabajo(:one)
  end

  def orden_aprobada
    @orden_trabajo.update!(estado: :aprobada)
  end

  test "should create detalle_orden_servicio" do
    orden_aprobada
    assert_difference("DetalleOrdenServicio.count") do
      post orden_trabajo_detalles_ordenes_servicios_url(@orden_trabajo), params: { detalle_orden_servicio: {
        servicio_id: servicios(:one).id, mecanico_id: mecanicos(:one).id, precio_aplicado: 1500
      } }
    end

    assert_redirected_to orden_trabajo_url(@orden_trabajo)
  end

  test "should destroy detalle_orden_servicio" do
    orden_aprobada
    detalle = @orden_trabajo.detalles_ordenes_servicios.create!(servicio: servicios(:one), mecanico: mecanicos(:one), precio_aplicado: 1500)
    assert_difference("DetalleOrdenServicio.count", -1) do
      delete orden_trabajo_detalle_orden_servicio_url(@orden_trabajo, detalle)
    end

    assert_redirected_to orden_trabajo_url(@orden_trabajo)
  end
end
