class EspecialidadesController < ApplicationController
  before_action :require_admin
  before_action :set_especialidad, only: %i[ show edit update destroy ]

  # GET /especialidades or /especialidades.json
  def index
    @especialidades = Especialidad.all
  end

  # GET /especialidades/1 or /especialidades/1.json
  def show
  end

  # GET /especialidades/new
  def new
    @especialidad = Especialidad.new
  end

  # GET /especialidades/1/edit
  def edit
  end

  # POST /especialidades or /especialidades.json
  def create
    @especialidad = Especialidad.new(especialidad_params)

    respond_to do |format|
      if @especialidad.save
        format.html { redirect_to @especialidad, notice: "Especialidad creado correctamente." }
        format.json { render :show, status: :created, location: @especialidad }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @especialidad.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /especialidades/1 or /especialidades/1.json
  def update
    respond_to do |format|
      if @especialidad.update(especialidad_params)
        format.html { redirect_to @especialidad, notice: "Especialidad actualizado correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @especialidad }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @especialidad.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /especialidades/1 or /especialidades/1.json
  def destroy
    destroy_with_errors(@especialidad, especialidades_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_especialidad
      @especialidad = Especialidad.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def especialidad_params
      params.expect(especialidad: [ :nombre, :descripcion ])
    end
end
