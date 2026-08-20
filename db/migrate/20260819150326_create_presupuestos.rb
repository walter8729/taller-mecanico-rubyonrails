class CreatePresupuestos < ActiveRecord::Migration[8.1]
  def change
    create_table :presupuestos do |t|
      t.references :orden_trabajo, null: false, foreign_key: true, index: false
      t.date :fecha, null: false
      t.decimal :monto_estimado, precision: 10, scale: 2
      t.string :estado, null: false, default: "pendiente"

      t.timestamps
    end
    add_index :presupuestos, :orden_trabajo_id, unique: true
  end
end
