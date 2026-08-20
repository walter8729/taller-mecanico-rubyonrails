require "test_helper"

class PresupuestosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    @orden_trabajo = ordenes_trabajo(:one)
  end

  def crear_orden_en_presupuestada
    @orden_trabajo.update!(estado: :en_diagnostico)
    @orden_trabajo.build_diagnostico(fecha: Date.today, descripcion: "Falla en frenos").save!
    @orden_trabajo.diagnostico.validar!
    @orden_trabajo.update!(estado: :presupuestada)
  end

  test "should get new" do
    get new_orden_trabajo_presupuesto_url(@orden_trabajo)
    assert_response :success
  end

  test "should create presupuesto" do
    crear_orden_en_presupuestada
    assert_difference("Presupuesto.count") do
      post orden_trabajo_presupuesto_url(@orden_trabajo), params: { presupuesto: {
        fecha: "2026-08-19", monto_estimado: 5000
      } }
    end

    assert_redirected_to orden_trabajo_url(@orden_trabajo)
  end

  test "should show presupuesto" do
    crear_orden_en_presupuestada
    @orden_trabajo.build_presupuesto(fecha: Date.today, monto_estimado: 5000).save!
    get orden_trabajo_presupuesto_url(@orden_trabajo)
    assert_response :success
  end

  test "should get edit" do
    crear_orden_en_presupuestada
    @orden_trabajo.build_presupuesto(fecha: Date.today, monto_estimado: 5000).save!
    get edit_orden_trabajo_presupuesto_url(@orden_trabajo)
    assert_response :success
  end

  test "should update presupuesto" do
    crear_orden_en_presupuestada
    presupuesto = @orden_trabajo.build_presupuesto(fecha: Date.today, monto_estimado: 5000)
    presupuesto.save!
    patch orden_trabajo_presupuesto_url(@orden_trabajo), params: { presupuesto: { monto_estimado: 6000 } }
    assert_redirected_to orden_trabajo_url(@orden_trabajo)
    assert_equal 6000, presupuesto.reload.monto_estimado
  end

  test "should aprobar presupuesto" do
    crear_orden_en_presupuestada
    @orden_trabajo.build_presupuesto(fecha: Date.today, monto_estimado: 5000).save!
    post aprobar_orden_trabajo_presupuesto_url(@orden_trabajo)
    assert_redirected_to orden_trabajo_url(@orden_trabajo)
    assert @orden_trabajo.presupuesto.reload.aprobado?
    assert @orden_trabajo.reload.aprobada?
  end

  test "should rechazar presupuesto" do
    crear_orden_en_presupuestada
    @orden_trabajo.build_presupuesto(fecha: Date.today, monto_estimado: 5000).save!
    post rechazar_orden_trabajo_presupuesto_url(@orden_trabajo)
    assert_redirected_to orden_trabajo_url(@orden_trabajo)
    assert @orden_trabajo.presupuesto.reload.rechazado?
    assert @orden_trabajo.reload.cancelada?
  end
end
