class CreateClientes < ActiveRecord::Migration[8.1]
  def change
    create_table :clientes do |t|
      t.string :nombre, null: false
      t.string :apellido
      t.string :telefono
      t.string :correo
      t.string :direccion
      t.string :estado, null: false, default: "activo"

      t.timestamps
    end
  end
end
