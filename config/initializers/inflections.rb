# Be sure to restart your server when you modify this file.

# Reglas de pluralización en español para el dominio del taller.
# Sin estas reglas, Rails pluraliza en inglés (especialidads, proveedors).
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "especialidad", "especialidades"
  inflect.irregular "proveedor", "proveedores"
  inflect.irregular "orden_trabajo", "ordenes_trabajo"
  inflect.irregular "orden_mecanico", "ordenes_mecanicos"
  inflect.irregular "detalle_orden_servicio", "detalles_ordenes_servicios"
  inflect.irregular "detalle_orden_repuesto", "detalles_ordenes_repuestos"
  inflect.irregular "bahia", "bahias"
end
