class CreateDetallesOrdenesServicios < ActiveRecord::Migration[8.1]
  def change
    create_table :detalles_ordenes_servicios do |t|
      t.references :orden_trabajo, null: false, foreign_key: true
      t.references :servicio, null: false, foreign_key: true
      t.references :mecanico, null: false, foreign_key: true
      t.decimal :precio_aplicado, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
