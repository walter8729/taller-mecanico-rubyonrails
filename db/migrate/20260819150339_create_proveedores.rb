class CreateProveedores < ActiveRecord::Migration[8.1]
  def change
    create_table :proveedores do |t|
      t.string :nombre, null: false
      t.string :telefono
      t.string :correo
      t.string :direccion
      t.string :estado, null: false, default: "activo"

      t.timestamps
    end
  end
end
