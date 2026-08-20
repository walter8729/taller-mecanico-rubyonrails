class CreateOrdenesTrabajo < ActiveRecord::Migration[8.1]
  def change
    create_table :ordenes_trabajo do |t|
      t.references :vehiculo, null: false, foreign_key: true
      t.references :bahia, null: false, foreign_key: true
      t.date :fecha_ingreso, null: false
      t.time :hora_ingreso, null: false
      t.integer :kilometraje_ingreso
      t.text :motivo_ingreso
      t.string :estado, null: false, default: "recibida"

      t.timestamps
    end
  end
end
