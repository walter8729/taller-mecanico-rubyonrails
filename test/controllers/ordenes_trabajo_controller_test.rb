require "test_helper"

class OrdenesTrabajoControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @orden_trabajo = ordenes_trabajo(:one)
  end

  test "should get index" do
    get ordenes_trabajo_url
    assert_response :success
  end

  test "should get new" do
    get new_orden_trabajo_url
    assert_response :success
  end

  test "should create orden_trabajo" do
    assert_difference("OrdenTrabajo.count") do
      post ordenes_trabajo_url, params: { orden_trabajo: {
        vehiculo_id: vehiculos(:one).id, bahia_id: bahias(:one).id,
        fecha_ingreso: "2026-08-19", hora_ingreso: "09:00:00",
        kilometraje_ingreso: 45000, motivo_ingreso: "Cambio de aceite"
      } }
    end

    assert_redirected_to orden_trabajo_url(OrdenTrabajo.last)
  end

  test "should show orden_trabajo" do
    get orden_trabajo_url(@orden_trabajo)
    assert_response :success
  end

  test "should transition to en_diagnostico" do
    post transicionar_orden_trabajo_url(@orden_trabajo, nuevo_estado: :en_diagnostico)
    assert_redirected_to orden_trabajo_url(@orden_trabajo)
    assert @orden_trabajo.reload.en_diagnostico?
  end

  test "should not transition to an invalid state" do
    post transicionar_orden_trabajo_url(@orden_trabajo, nuevo_estado: :entregada)
    assert_redirected_to orden_trabajo_url(@orden_trabajo)
    assert @orden_trabajo.reload.recibida?
  end

  test "should cancelar" do
    @orden_trabajo.update!(estado: :presupuestada)
    post cancelar_orden_trabajo_url(@orden_trabajo)
    assert_redirected_to orden_trabajo_url(@orden_trabajo)
    assert @orden_trabajo.reload.cancelada?
  end

  test "should finalizar" do
    orden = ordenes_trabajo(:two)
    orden.update!(estado: :en_reparacion)
    post finalizar_orden_trabajo_url(orden)
    assert_redirected_to orden_trabajo_url(orden)
    assert orden.reload.finalizada?
  end
end
