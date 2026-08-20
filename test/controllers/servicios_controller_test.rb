require "test_helper"

class ServiciosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @servicio = servicios(:one)
  end

  test "should get index" do
    get servicios_url
    assert_response :success
  end

  test "should get new" do
    get new_servicio_url
    assert_response :success
  end

  test "should create servicio" do
    assert_difference("Servicio.count") do
      post servicios_url, params: { servicio: { descripcion: "Servicio nuevo", nombre: "Balanceo", precio_base: 1200 } }
    end

    assert_redirected_to servicio_url(Servicio.last)
  end

  test "should show servicio" do
    get servicio_url(@servicio)
    assert_response :success
  end

  test "should get edit" do
    get edit_servicio_url(@servicio)
    assert_response :success
  end

  test "should update servicio" do
    patch servicio_url(@servicio), params: { servicio: { descripcion: @servicio.descripcion, nombre: @servicio.nombre, precio_base: @servicio.precio_base } }
    assert_redirected_to servicio_url(@servicio)
  end

  test "should destroy servicio" do
    @servicio = Servicio.create!(nombre: "Para borrar", precio_base: 500)
    assert_difference("Servicio.count", -1) do
      delete servicio_url(@servicio)
    end

    assert_redirected_to servicios_url
  end
end
