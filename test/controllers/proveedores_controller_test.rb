require "test_helper"

class ProveedoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @proveedor = proveedores(:one)
  end

  test "should get index" do
    get proveedores_url
    assert_response :success
  end

  test "should get new" do
    get new_proveedor_url
    assert_response :success
  end

  test "should create proveedor" do
    assert_difference("Proveedor.count") do
      post proveedores_url, params: { proveedor: { correo: "nuevo@example.com", direccion: "Av. Nueva", nombre: "Proveedor Nuevo", telefono: "77777777" } }
    end

    assert_redirected_to proveedor_url(Proveedor.last)
  end

  test "should show proveedor" do
    get proveedor_url(@proveedor)
    assert_response :success
  end

  test "should get edit" do
    get edit_proveedor_url(@proveedor)
    assert_response :success
  end

  test "should update proveedor" do
    patch proveedor_url(@proveedor), params: { proveedor: { correo: @proveedor.correo, direccion: @proveedor.direccion, nombre: @proveedor.nombre, telefono: @proveedor.telefono } }
    assert_redirected_to proveedor_url(@proveedor)
  end

  test "should destroy proveedor" do
    @proveedor = Proveedor.create!(nombre: "Para borrar", telefono: "999")
    assert_difference("Proveedor.count", -1) do
      delete proveedor_url(@proveedor)
    end

    assert_redirected_to proveedores_url
  end
end
