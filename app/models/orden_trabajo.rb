class OrdenTrabajo < ApplicationRecord
  enum :estado, {
    recibida: "recibida",
    en_diagnostico: "en_diagnostico",
    presupuestada: "presupuestada",
    aprobada: "aprobada",
    en_reparacion: "en_reparacion",
    finalizada: "finalizada",
    entregada: "entregada",
    cancelada: "cancelada"
  }, default: :recibida

  TRANSICIONES = {
    en_diagnostico: :recibida,
    presupuestada: :en_diagnostico,
    aprobada: :presupuestada,
    en_reparacion: :aprobada,
    finalizada: :en_reparacion,
    entregada: :finalizada,
    cancelada: :presupuestada
  }.freeze

  belongs_to :vehiculo
  belongs_to :bahia

  has_one :diagnostico, dependent: :restrict_with_error
  has_one :presupuesto, dependent: :restrict_with_error
  has_one :factura, dependent: :restrict_with_error

  has_many :ordenes_mecanicos, dependent: :destroy
  has_many :mecanicos, through: :ordenes_mecanicos
  has_many :detalles_ordenes_servicios, dependent: :destroy
  has_many :servicios, through: :detalles_ordenes_servicios
  has_many :detalles_ordenes_repuestos, dependent: :destroy
  has_many :repuestos, through: :detalles_ordenes_repuestos

  validates :fecha_ingreso, :hora_ingreso, :motivo_ingreso, presence: true

  validate :bahia_asignable, on: :create

  scope :activas, -> { where.not(estado: [ :entregada, :cancelada ]) }
  scope :recientes, -> { order(fecha_ingreso: :desc, created_at: :desc) }

  after_create :ocupar_bahia

  def total_servicios
    detalles_ordenes_servicios.sum(:precio_aplicado)
  end

  def total_repuestos
    detalles_ordenes_repuestos.sum("cantidad * precio_unitario")
  end

  def total
    total_servicios + total_repuestos
  end

  def transicionar_a!(nuevo_estado)
    estado_anterior = TRANSICIONES[nuevo_estado.to_sym]
    unless estado_anterior && public_send("#{estado_anterior}?")
      errors.add(:estado, "no es posible pasar de #{estado} a #{nuevo_estado}")
      return false
    end

    if nuevo_estado.to_sym == :en_reparacion && presupuesto&.estado != "aprobado"
      errors.add(:estado, "la reparación no puede iniciar sin un presupuesto aprobado")
      return false
    end

    transaction do
      update!(estado: nuevo_estado)
      sincronizar_bahia
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def cancelar!
    return false unless transicionar_a!(:cancelada)

    presupuesto&.update!(estado: :rechazado)
    true
  end

  def finalizar!
    return false unless transicionar_a!(:finalizada)

    sincronizar_bahia
    true
  end

  private
    def bahia_asignable
      return if bahia.nil? || bahia.disponible?
      errors.add(:bahia, "no está disponible (solo se puede asignar una bahía disponible)")
    end

    def ocupar_bahia
      bahia.update!(estado: :ocupada)
    end

    def sincronizar_bahia
      if entregada? || cancelada?
        bahia.update!(estado: :disponible) unless bahia.disponible?
      elsif !bahia.ocupada?
        bahia.update!(estado: :ocupada)
      end
    end
end
