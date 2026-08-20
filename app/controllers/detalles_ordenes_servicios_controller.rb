class DetallesOrdenesServiciosController < ApplicationController
  before_action :set_orden_trabajo, only: [ :create ]

  def create
    @detalle = @orden_trabajo.detalles_ordenes_servicios.new(detalle_params)

    if @detalle.save
      redirect_to @orden_trabajo, notice: "Servicio agregado a la orden."
    else
      redirect_to @orden_trabajo, alert: @detalle.errors.full_messages.join(", ")
    end
  end

  def destroy
    @detalle = DetalleOrdenServicio.find(params.expect(:id))
    orden = @detalle.orden_trabajo
    @detalle.destroy
    redirect_to orden, notice: "Servicio quitado de la orden."
  end

  private
    def set_orden_trabajo
      @orden_trabajo = OrdenTrabajo.find(params.expect(:orden_trabajo_id))
    end

    def detalle_params
      params.expect(detalle_orden_servicio: [ :servicio_id, :mecanico_id, :precio_aplicado ])
    end
end
