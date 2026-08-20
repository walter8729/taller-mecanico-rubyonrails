class DiagnosticosController < ApplicationController
  before_action :set_orden_trabajo
  before_action :set_diagnostico

  def new
    @diagnostico = @orden_trabajo.build_diagnostico
  end

  def create
    @diagnostico = @orden_trabajo.build_diagnostico(diagnostico_params)

    if @diagnostico.save
      redirect_to @orden_trabajo, notice: "Diagnóstico registrado correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def edit
  end

  def update
    if @diagnostico.update(diagnostico_params)
      redirect_to @orden_trabajo, notice: "Diagnóstico actualizado correctamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def validar
    if @diagnostico&.validar!
      redirect_to @orden_trabajo, notice: "Diagnóstico validado."
    else
      redirect_to @orden_trabajo, alert: "No se pudo validar el diagnóstico."
    end
  end

  private
    def set_orden_trabajo
      @orden_trabajo = OrdenTrabajo.find(params.expect(:orden_trabajo_id))
    end

    def set_diagnostico
      @diagnostico = @orden_trabajo.diagnostico
    end

    def diagnostico_params
      params.expect(diagnostico: [ :fecha, :descripcion, :observaciones ])
    end
end
