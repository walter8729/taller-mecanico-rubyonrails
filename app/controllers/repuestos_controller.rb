class RepuestosController < ApplicationController
  before_action :require_admin_or_recepcionista
  before_action :set_repuesto, only: %i[ show edit update destroy ]

  # GET /repuestos or /repuestos.json
  def index
    @repuestos = Repuesto.all
  end

  # GET /repuestos/1 or /repuestos/1.json
  def show
  end

  # GET /repuestos/new
  def new
    @repuesto = Repuesto.new
  end

  # GET /repuestos/1/edit
  def edit
  end

  # POST /repuestos or /repuestos.json
  def create
    @repuesto = Repuesto.new(repuesto_params)

    respond_to do |format|
      if @repuesto.save
        format.html { redirect_to @repuesto, notice: "Repuesto creado correctamente." }
        format.json { render :show, status: :created, location: @repuesto }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @repuesto.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /repuestos/1 or /repuestos/1.json
  def update
    respond_to do |format|
      if @repuesto.update(repuesto_params)
        format.html { redirect_to @repuesto, notice: "Repuesto actualizado correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @repuesto }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @repuesto.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /repuestos/1 or /repuestos/1.json
  def destroy
    destroy_with_errors(@repuesto, repuestos_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repuesto
      @repuesto = Repuesto.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def repuesto_params
      params.expect(repuesto: [ :proveedor_id, :nombre, :marca, :modelo_compatible, :precio, :stock ])
    end
end
