require "test_helper"

class RepuestosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @repuesto = repuestos(:one)
  end

  test "should get index" do
    get repuestos_url
    assert_response :success
  end

  test "should get new" do
    get new_repuesto_url
    assert_response :success
  end

  test "should create repuesto" do
    assert_difference("Repuesto.count") do
      post repuestos_url, params: { repuesto: { marca: "Nuevo", modelo_compatible: "Versa", nombre: "Bujias", precio: 150, proveedor_id: @repuesto.proveedor_id, stock: 20 } }
    end

    assert_redirected_to repuesto_url(Repuesto.last)
  end

  test "should show repuesto" do
    get repuesto_url(@repuesto)
    assert_response :success
  end

  test "should get edit" do
    get edit_repuesto_url(@repuesto)
    assert_response :success
  end

  test "should update repuesto" do
    patch repuesto_url(@repuesto), params: { repuesto: { marca: @repuesto.marca, modelo_compatible: @repuesto.modelo_compatible, nombre: @repuesto.nombre, precio: @repuesto.precio, proveedor_id: @repuesto.proveedor_id, stock: @repuesto.stock } }
    assert_redirected_to repuesto_url(@repuesto)
  end

  test "should destroy repuesto" do
    @repuesto = Repuesto.create!(proveedor: proveedores(:two), nombre: "Para borrar", precio: 100, stock: 1)
    assert_difference("Repuesto.count", -1) do
      delete repuesto_url(@repuesto)
    end

    assert_redirected_to repuestos_url
  end
end
