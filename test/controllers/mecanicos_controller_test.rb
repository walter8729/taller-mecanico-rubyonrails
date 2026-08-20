require "test_helper"

class MecanicosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @mecanico = mecanicos(:one)
  end

  test "should get index" do
    get mecanicos_url
    assert_response :success
  end

  test "should get new" do
    get new_mecanico_url
    assert_response :success
  end

  test "should create mecanico" do
    assert_difference("Mecanico.count") do
      post mecanicos_url, params: { mecanico: { apellido: @mecanico.apellido, correo: @mecanico.correo, especialidad_id: @mecanico.especialidad_id, nombre: @mecanico.nombre, telefono: @mecanico.telefono } }
    end

    assert_redirected_to mecanico_url(Mecanico.last)
  end

  test "should show mecanico" do
    get mecanico_url(@mecanico)
    assert_response :success
  end

  test "should get edit" do
    get edit_mecanico_url(@mecanico)
    assert_response :success
  end

  test "should update mecanico" do
    patch mecanico_url(@mecanico), params: { mecanico: { apellido: @mecanico.apellido, correo: @mecanico.correo, especialidad_id: @mecanico.especialidad_id, nombre: @mecanico.nombre, telefono: @mecanico.telefono } }
    assert_redirected_to mecanico_url(@mecanico)
  end

  test "should destroy mecanico" do
    @mecanico = Mecanico.create!(especialidad: especialidades(:one), nombre: "Para borrar", apellido: "Mecanico")
    assert_difference("Mecanico.count", -1) do
      delete mecanico_url(@mecanico)
    end

    assert_redirected_to mecanicos_url
  end
end
