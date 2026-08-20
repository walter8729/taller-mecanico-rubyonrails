class MecanicosController < ApplicationController
  before_action :require_admin
  before_action :set_mecanico, only: %i[ show edit update destroy ]

  # GET /mecanicos or /mecanicos.json
  def index
    @mecanicos = Mecanico.all
  end

  # GET /mecanicos/1 or /mecanicos/1.json
  def show
  end

  # GET /mecanicos/new
  def new
    @mecanico = Mecanico.new
  end

  # GET /mecanicos/1/edit
  def edit
  end

  # POST /mecanicos or /mecanicos.json
  def create
    @mecanico = Mecanico.new(mecanico_params)

    respond_to do |format|
      if @mecanico.save
        format.html { redirect_to @mecanico, notice: "Mecanico creado correctamente." }
        format.json { render :show, status: :created, location: @mecanico }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @mecanico.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /mecanicos/1 or /mecanicos/1.json
  def update
    respond_to do |format|
      if @mecanico.update(mecanico_params)
        format.html { redirect_to @mecanico, notice: "Mecanico actualizado correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @mecanico }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @mecanico.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /mecanicos/1 or /mecanicos/1.json
  def destroy
    destroy_with_errors(@mecanico, mecanicos_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mecanico
      @mecanico = Mecanico.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def mecanico_params
      params.expect(mecanico: [ :nombre, :apellido, :telefono, :correo, :especialidad_id ])
    end
end
