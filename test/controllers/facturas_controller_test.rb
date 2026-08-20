require "test_helper"

class FacturasControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @factura = facturas(:one)
  end

  test "should get index" do
    get facturas_url
    assert_response :success
  end

  test "should get new" do
    get new_factura_url
    assert_response :success
  end

  test "should create factura" do
    orden = ordenes_trabajo(:two)
    orden.update!(estado: :entregada)
    assert_difference("Factura.count") do
      post facturas_url, params: { factura: { orden_trabajo_id: orden.id, fecha: "2026-08-19" } }
    end

    assert_redirected_to factura_url(Factura.last)
  end

  test "should show factura" do
    get factura_url(@factura)
    assert_response :success
  end

  test "should pagar factura" do
    orden = ordenes_trabajo(:two)
    orden.update!(estado: :entregada)
    factura = Factura.create!(orden_trabajo: orden, fecha: Date.today)
    post pagar_factura_url(factura)
    assert_redirected_to factura_url(factura)
    assert factura.reload.pagada?
  end
end
