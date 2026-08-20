class OrdenesMecanicosController < ApplicationController
  before_action :set_orden_trabajo, only: [ :create ]

  def create
    @orden_mecanico = @orden_trabajo.ordenes_mecanicos.new(orden_mecanico_params)

    if @orden_mecanico.save
      redirect_to @orden_trabajo, notice: "Mecánico asignado correctamente."
    else
      redirect_to @orden_trabajo, alert: @orden_mecanico.errors.full_messages.join(", ")
    end
  end

  def destroy
    @orden_mecanico = OrdenMecanico.find(params.expect(:id))
    orden = @orden_mecanico.orden_trabajo
    @orden_mecanico.destroy
    redirect_to orden, notice: "Mecánico quitado de la orden."
  end

  private
    def set_orden_trabajo
      @orden_trabajo = OrdenTrabajo.find(params.expect(:orden_trabajo_id))
    end

    def orden_mecanico_params
      params.expect(orden_mecanico: [ :mecanico_id, :rol ])
    end
end
