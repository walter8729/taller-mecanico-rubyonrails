require "test_helper"

class DetallesOrdenesRepuestosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @orden_trabajo = ordenes_trabajo(:one)
  end

  def orden_aprobada
    @orden_trabajo.update!(estado: :aprobada)
  end

  test "should create detalle_orden_repuesto" do
    orden_aprobada
    assert_difference("DetalleOrdenRepuesto.count") do
      post orden_trabajo_detalles_ordenes_repuestos_url(@orden_trabajo), params: { detalle_orden_repuesto: {
        repuesto_id: repuestos(:one).id, cantidad: 1, precio_unitario: 200
      } }
    end

    assert_redirected_to orden_trabajo_url(@orden_trabajo)
  end

  test "should destroy detalle_orden_repuesto" do
    orden_aprobada
    detalle = @orden_trabajo.detalles_ordenes_repuestos.create!(repuesto: repuestos(:one), cantidad: 1, precio_unitario: 200)
    assert_difference("DetalleOrdenRepuesto.count", -1) do
      delete orden_trabajo_detalle_orden_repuesto_url(@orden_trabajo, detalle)
    end

    assert_redirected_to orden_trabajo_url(@orden_trabajo)
  end
end
