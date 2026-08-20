class CreateFacturas < ActiveRecord::Migration[8.1]
  def change
    create_table :facturas do |t|
      t.references :cliente, null: false, foreign_key: true
      t.references :orden_trabajo, null: false, foreign_key: true, index: false
      t.date :fecha, null: false
      t.decimal :monto_total, precision: 10, scale: 2, null: false
      t.string :estado, null: false, default: "pendiente"

      t.timestamps
    end
    add_index :facturas, :orden_trabajo_id, unique: true
  end
end
