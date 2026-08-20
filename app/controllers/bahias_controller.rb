class BahiasController < ApplicationController
  before_action :require_admin
  before_action :set_bahia, only: %i[ show edit update destroy ]

  # GET /bahias or /bahias.json
  def index
    @bahias = Bahia.all
  end

  # GET /bahias/1 or /bahias/1.json
  def show
  end

  # GET /bahias/new
  def new
    @bahia = Bahia.new
  end

  # GET /bahias/1/edit
  def edit
  end

  # POST /bahias or /bahias.json
  def create
    @bahia = Bahia.new(bahia_params)

    respond_to do |format|
      if @bahia.save
        format.html { redirect_to @bahia, notice: "Bahia creado correctamente." }
        format.json { render :show, status: :created, location: @bahia }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @bahia.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /bahias/1 or /bahias/1.json
  def update
    respond_to do |format|
      if @bahia.update(bahia_params)
        format.html { redirect_to @bahia, notice: "Bahia actualizado correctamente.", status: :see_other }
        format.json { render :show, status: :ok, location: @bahia }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @bahia.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /bahias/1 or /bahias/1.json
  def destroy
    destroy_with_errors(@bahia, bahias_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bahia
      @bahia = Bahia.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def bahia_params
      params.expect(bahia: [ :numero, :tipo, :estado ])
    end
end
