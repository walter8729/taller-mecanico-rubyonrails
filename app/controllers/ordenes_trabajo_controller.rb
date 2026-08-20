class OrdenesTrabajoController < ApplicationController
  before_action :set_orden_trabajo, only: %i[ show transicionar cancelar finalizar ]

  def index
    @activas = OrdenTrabajo.activas.recientes.includes(:vehiculo, :bahia)
    @finalizadas = OrdenTrabajo.where(estado: [ :entregada, :cancelada ]).recientes.limit(20)
  end

  def show
  end

  def new
    @orden_trabajo = OrdenTrabajo.new
  end

  def create
    @orden_trabajo = OrdenTrabajo.new(orden_trabajo_params)

    if @orden_trabajo.save
      redirect_to @orden_trabajo, notice: "Orden de trabajo creada correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def transicionar
    if @orden_trabajo.transicionar_a!(params[:nuevo_estado])
      redirect_to @orden_trabajo, notice: "Estado actualizado a #{@orden_trabajo.estado}."
    else
      redirect_to @orden_trabajo, alert: @orden_trabajo.errors.full_messages.join(", ")
    end
  end

  def cancelar
    if @orden_trabajo.cancelar!
      redirect_to @orden_trabajo, notice: "Orden cancelada."
    else
      redirect_to @orden_trabajo, alert: @orden_trabajo.errors.full_messages.join(", ")
    end
  end

  def finalizar
    if @orden_trabajo.finalizar!
      redirect_to @orden_trabajo, notice: "Orden finalizada."
    else
      redirect_to @orden_trabajo, alert: @orden_trabajo.errors.full_messages.join(", ")
    end
  end

  private
    def set_orden_trabajo
      @orden_trabajo = OrdenTrabajo.find(params.expect(:id))
    end

    def orden_trabajo_params
      params.expect(orden_trabajo: [ :vehiculo_id, :bahia_id, :fecha_ingreso, :hora_ingreso, :kilometraje_ingreso, :motivo_ingreso ])
    end
end
