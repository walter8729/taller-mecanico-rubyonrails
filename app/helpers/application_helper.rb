module ApplicationHelper
  ESTADOS_BADGE = {
    "activo" => "badge badge-exito",
    "inactivo" => "badge",
    "disponible" => "badge badge-exito",
    "ocupada" => "badge badge-info",
    "mantenimiento" => "badge badge-acento",
    "recibida" => "badge badge-info",
    "en_diagnostico" => "badge badge-info",
    "presupuestada" => "badge badge-acento",
    "aprobada" => "badge badge-exito",
    "en_reparacion" => "badge badge-info",
    "finalizada" => "badge badge-exito",
    "entregada" => "badge badge-exito",
    "cancelada" => "badge badge-peligro",
    "pendiente" => "badge badge-acento",
    "aprobado" => "badge badge-exito",
    "rechazado" => "badge badge-peligro",
    "registrado" => "badge badge-info",
    "validado" => "badge badge-exito",
    "pagada" => "badge badge-exito",
    "encargado" => "badge badge-info",
    "ayudante" => "badge badge-secondary"
  }.freeze

  def badge_estado(estado)
    css = ESTADOS_BADGE.fetch(estado.to_s, "badge")
    content_tag(:span, estado.to_s.tr("_", " ").capitalize, class: css)
  end
end
