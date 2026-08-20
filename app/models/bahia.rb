class Bahia < ApplicationRecord
  enum :tipo, { elevador: "elevador", fosa: "fosa", plataforma: "plataforma" }, default: :elevador
  enum :estado, { disponible: "disponible", ocupada: "ocupada", mantenimiento: "mantenimiento" }, default: :disponible

  has_many :ordenes_trabajo, dependent: :restrict_with_error

  validates :numero, presence: true, uniqueness: true

  scope :disponibles, -> { where(estado: :disponible) }
  scope :asignables, -> { where.not(estado: :mantenimiento) }
end
