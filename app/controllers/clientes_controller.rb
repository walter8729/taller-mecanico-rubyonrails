class ClientesController < ApplicationController
  before_action :require_admin_or_recepcionista
  before_action :set_cliente, only: %i[ show edit update destroy ]

  # GET /clientes or /clientes.json
  def index
    @clientes = Cliente.all
  end

  # GET /clientes/1 or /clientes/1.json
  def show
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes or /clientes.json
  def create
    @cliente = Cliente.new(cliente_params)

    respond_to do |format|
      if @cliente.save
        format.html { redirect_to @cliente, notice: "Cliente creado correctamente." }
        format.json { render :show, status: :created, location: @cliente }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @cliente.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /clientes/1 or /clientes/1.json
  def update
    respond_to do |format|
      if @cliente.update(cliente_params)
        format.html { redirect_to @cliente, notice: "Cliente actualizado correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @cliente }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @cliente.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /clientes/1 or /clientes/1.json
  def destroy
    destroy_with_errors(@cliente, clientes_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def cliente_params
      params.expect(cliente: [ :nombre, :apellido, :telefono, :correo, :direccion ])
    end
end
