class Especialidad < ApplicationRecord
  enum :estado, { activo: "activo", inactivo: "inactivo" }, default: :activo

  has_many :mecanicos, dependent: :restrict_with_error

  validates :nombre, presence: true, uniqueness: true

  scope :activas, -> { where(estado: :activo) }
end
