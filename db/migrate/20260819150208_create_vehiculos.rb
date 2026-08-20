class CreateVehiculos < ActiveRecord::Migration[8.1]
  def change
    create_table :vehiculos do |t|
      t.references :cliente, null: false, foreign_key: true
      t.string :placa, null: false
      t.string :marca, null: false
      t.string :modelo, null: false
      t.integer :anio
      t.string :color
      t.integer :kilometraje
      t.string :estado, null: false, default: "activo"

      t.timestamps
    end
  end
end
