require "test_helper"

class DiagnosticosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @orden_trabajo = ordenes_trabajo(:one)
  end

  test "should get new" do
    get new_orden_trabajo_diagnostico_url(@orden_trabajo)
    assert_response :success
  end

  test "should create diagnostico" do
    @orden_trabajo.update!(estado: :en_diagnostico)
    assert_difference("Diagnostico.count") do
      post orden_trabajo_diagnostico_url(@orden_trabajo), params: { diagnostico: {
        fecha: "2026-08-19", descripcion: "Falla en frenos", observaciones: ""
      } }
    end

    assert_redirected_to orden_trabajo_url(@orden_trabajo)
  end

  test "should show diagnostico" do
    @orden_trabajo.update!(estado: :en_diagnostico)
    @orden_trabajo.build_diagnostico(fecha: Date.today, descripcion: "Falla en frenos").save!
    get orden_trabajo_diagnostico_url(@orden_trabajo)
    assert_response :success
  end

  test "should get edit" do
    @orden_trabajo.update!(estado: :en_diagnostico)
    @orden_trabajo.build_diagnostico(fecha: Date.today, descripcion: "Falla en frenos").save!
    get edit_orden_trabajo_diagnostico_url(@orden_trabajo)
    assert_response :success
  end

  test "should update diagnostico" do
    @orden_trabajo.update!(estado: :en_diagnostico)
    diagnostico = @orden_trabajo.build_diagnostico(fecha: Date.today, descripcion: "Falla en frenos")
    diagnostico.save!
    patch orden_trabajo_diagnostico_url(@orden_trabajo), params: { diagnostico: { descripcion: "Actualizado" } }
    assert_redirected_to orden_trabajo_url(@orden_trabajo)
    assert_equal "Actualizado", diagnostico.reload.descripcion
  end

  test "should validar diagnostico" do
    @orden_trabajo.update!(estado: :en_diagnostico)
    @orden_trabajo.build_diagnostico(fecha: Date.today, descripcion: "Falla en frenos").save!
    post validar_orden_trabajo_diagnostico_url(@orden_trabajo)
    assert_redirected_to orden_trabajo_url(@orden_trabajo)
    assert @orden_trabajo.diagnostico.reload.validado?
  end
end
