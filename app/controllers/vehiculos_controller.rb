class VehiculosController < ApplicationController
  before_action :require_admin_or_recepcionista
  before_action :set_vehiculo, only: %i[ show edit update destroy ]

  # GET /vehiculos or /vehiculos.json
  def index
    @vehiculos = Vehiculo.all
  end

  # GET /vehiculos/1 or /vehiculos/1.json
  def show
  end

  # GET /vehiculos/new
  def new
    @vehiculo = Vehiculo.new
  end

  # GET /vehiculos/1/edit
  def edit
  end

  # POST /vehiculos or /vehiculos.json
  def create
    @vehiculo = Vehiculo.new(vehiculo_params)

    respond_to do |format|
      if @vehiculo.save
        format.html { redirect_to @vehiculo, notice: "Vehículo creado correctamente." }
        format.json { render :show, status: :created, location: @vehiculo }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @vehiculo.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /vehiculos/1 or /vehiculos/1.json
  def update
    respond_to do |format|
      if @vehiculo.update(vehiculo_params)
        format.html { redirect_to @vehiculo, notice: "Vehículo actualizado correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @vehiculo }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @vehiculo.errors, status: :unprocessable_content }
      end
    end
  end

# DELETE /vehiculos/1 or /vehiculos/1.json
def destroy
    destroy_with_errors(@vehiculo, vehiculos_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehiculo
      @vehiculo = Vehiculo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def vehiculo_params
      params.expect(vehiculo: [ :cliente_id, :placa, :marca, :modelo, :anio, :color, :kilometraje ])
    end
end
