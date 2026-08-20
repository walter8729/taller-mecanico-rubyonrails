class OrdenMecanico < ApplicationRecord
  enum :rol, { encargado: "encargado", ayudante: "ayudante" }, default: :ayudante

  belongs_to :orden_trabajo
  belongs_to :mecanico

  validates :rol, inclusion: { in: rols.keys }
  validates :mecanico_id, uniqueness: { scope: :orden_trabajo_id }
end
