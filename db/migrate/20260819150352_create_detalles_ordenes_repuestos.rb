class CreateDetallesOrdenesRepuestos < ActiveRecord::Migration[8.1]
  def change
    create_table :detalles_ordenes_repuestos do |t|
      t.references :orden_trabajo, null: false, foreign_key: true
      t.references :repuesto, null: false, foreign_key: true
      t.integer :cantidad, null: false, default: 1
      t.decimal :precio_unitario, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
