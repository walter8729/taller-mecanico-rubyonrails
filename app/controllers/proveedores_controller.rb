class ProveedoresController < ApplicationController
  before_action :require_admin
  before_action :set_proveedor, only: %i[ show edit update destroy ]

  # GET /proveedores or /proveedores.json
  def index
    @proveedores = Proveedor.all
  end

  # GET /proveedores/1 or /proveedores/1.json
  def show
  end

  # GET /proveedores/new
  def new
    @proveedor = Proveedor.new
  end

  # GET /proveedores/1/edit
  def edit
  end

  # POST /proveedores or /proveedores.json
  def create
    @proveedor = Proveedor.new(proveedor_params)

    respond_to do |format|
      if @proveedor.save
        format.html { redirect_to @proveedor, notice: "Proveedor creado correctamente." }
        format.json { render :show, status: :created, location: @proveedor }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @proveedor.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /proveedores/1 or /proveedores/1.json
  def update
    respond_to do |format|
      if @proveedor.update(proveedor_params)
        format.html { redirect_to @proveedor, notice: "Proveedor actualizado correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @proveedor }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @proveedor.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /proveedores/1 or /proveedores/1.json
  def destroy
    destroy_with_errors(@proveedor, proveedores_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proveedor
      @proveedor = Proveedor.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def proveedor_params
      params.expect(proveedor: [ :nombre, :telefono, :correo, :direccion ])
    end
end
