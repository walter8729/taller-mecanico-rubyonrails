require "test_helper"

class OrdenesMecanicosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @orden_trabajo = ordenes_trabajo(:one)
  end

  test "should create orden_mecanico" do
    assert_difference("OrdenMecanico.count") do
      post orden_trabajo_ordenes_mecanicos_url(@orden_trabajo), params: { orden_mecanico: {
        mecanico_id: mecanicos(:two).id, rol: "encargado"
      } }
    end

    assert_redirected_to orden_trabajo_url(@orden_trabajo)
  end

  test "should destroy orden_mecanico" do
    orden_mecanico = ordenes_mecanicos(:one)
    assert_difference("OrdenMecanico.count", -1) do
      delete orden_trabajo_orden_mecanico_url(@orden_trabajo, orden_mecanico)
    end

    assert_redirected_to orden_trabajo_url(@orden_trabajo)
  end
end
