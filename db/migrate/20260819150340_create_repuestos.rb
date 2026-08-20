class CreateRepuestos < ActiveRecord::Migration[8.1]
  def change
    create_table :repuestos do |t|
      t.references :proveedor, null: false, foreign_key: true
      t.string :nombre, null: false
      t.string :marca
      t.string :modelo_compatible
      t.decimal :precio, precision: 10, scale: 2, null: false
      t.integer :stock, null: false, default: 0
      t.string :estado, null: false, default: "activo"

      t.timestamps
    end
  end
end
