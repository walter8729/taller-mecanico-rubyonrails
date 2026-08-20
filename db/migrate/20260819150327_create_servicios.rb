class CreateServicios < ActiveRecord::Migration[8.1]
  def change
    create_table :servicios do |t|
      t.string :nombre, null: false
      t.text :descripcion
      t.decimal :precio_base, precision: 10, scale: 2, null: false
      t.string :estado, null: false, default: "activo"

      t.timestamps
    end
  end
end
