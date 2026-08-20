class CreateOrdenesMecanicos < ActiveRecord::Migration[8.1]
  def change
    create_table :ordenes_mecanicos do |t|
      t.references :orden_trabajo, null: false, foreign_key: true
      t.references :mecanico, null: false, foreign_key: true
      t.string :rol, null: false, default: "ayudante"

      t.timestamps
    end
    add_index :ordenes_mecanicos, [ :orden_trabajo_id, :mecanico_id ], unique: true
  end
end
