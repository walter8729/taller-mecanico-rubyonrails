class DetallesOrdenesRepuestosController < ApplicationController
  before_action :set_orden_trabajo, only: [ :create ]

  def create
    @detalle = @orden_trabajo.detalles_ordenes_repuestos.new(detalle_params)

    if @detalle.save
      redirect_to @orden_trabajo, notice: "Repuesto agregado a la orden y stock descontado."
    else
      redirect_to @orden_trabajo, alert: @detalle.errors.full_messages.join(", ")
    end
  end

  def destroy
    @detalle = DetalleOrdenRepuesto.find(params.expect(:id))
    orden = @detalle.orden_trabajo
    @detalle.destroy
    redirect_to orden, notice: "Repuesto quitado de la orden."
  end

  private
    def set_orden_trabajo
      @orden_trabajo = OrdenTrabajo.find(params.expect(:orden_trabajo_id))
    end

    def detalle_params
      params.expect(detalle_orden_repuesto: [ :repuesto_id, :cantidad, :precio_unitario ])
    end
end
