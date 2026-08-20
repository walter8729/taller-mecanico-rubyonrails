class PresupuestosController < ApplicationController
  before_action :set_orden_trabajo
  before_action :set_presupuesto, except: [ :new, :create ]

  def new
    @presupuesto = @orden_trabajo.build_presupuesto
  end

  def create
    @presupuesto = @orden_trabajo.build_presupuesto(presupuesto_params)

    if @presupuesto.save
      redirect_to @orden_trabajo, notice: "Presupuesto generado correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def edit
  end

  def update
    if @presupuesto.update(presupuesto_params)
      redirect_to @orden_trabajo, notice: "Presupuesto actualizado correctamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def aprobar
    if @presupuesto.aprobar!
      redirect_to @orden_trabajo, notice: "Presupuesto aprobado. La orden quedó aprobada."
    else
      redirect_to @orden_trabajo, alert: @presupuesto.errors.full_messages.join(", ")
    end
  end

  def rechazar
    if @presupuesto.rechazar!
      redirect_to @orden_trabajo, notice: "Presupuesto rechazado. La orden quedó cancelada."
    else
      redirect_to @orden_trabajo, alert: @presupuesto.errors.full_messages.join(", ")
    end
  end

  private
    def set_orden_trabajo
      @orden_trabajo = OrdenTrabajo.find(params.expect(:orden_trabajo_id))
    end

    def set_presupuesto
      @presupuesto = @orden_trabajo.presupuesto
    end

    def presupuesto_params
      params.expect(presupuesto: [ :fecha, :monto_estimado ])
    end
end
