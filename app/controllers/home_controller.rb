class HomeController < ApplicationController
  def index
    @ordenes_activas = OrdenTrabajo.activas.count
    @ordenes_en_reparacion = OrdenTrabajo.where(estado: :en_reparacion).count
    @bahias_ocupadas = Bahia.where(estado: :ocupada).count
    @facturas_pendientes = Factura.where(estado: :pendiente).count
    @repuestos_con_poco_stock = Repuesto.activos.where("stock <= 3").count
  end
end
