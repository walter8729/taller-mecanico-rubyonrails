class FacturasController < ApplicationController
  before_action :set_factura, only: %i[ show pagar ]

  def index
    @facturas = Factura.includes(:cliente, :orden_trabajo).order(fecha: :desc)
  end

  def show
  end

  def new
    @factura = Factura.new
  end

  def create
    @factura = Factura.new(factura_params)

    if @factura.save
      redirect_to @factura, notice: "Factura generada correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def pagar
    if @factura.pagar!
      redirect_to @factura, notice: "Factura marcada como pagada."
    else
      redirect_to @factura, alert: @factura.errors.full_messages.join(", ")
    end
  end

  private
    def set_factura
      @factura = Factura.find(params.expect(:id))
    end

    def factura_params
      params.expect(factura: [ :orden_trabajo_id, :fecha ])
    end
end
