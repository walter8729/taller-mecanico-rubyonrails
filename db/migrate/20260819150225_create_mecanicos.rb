class CreateMecanicos < ActiveRecord::Migration[8.1]
  def change
    create_table :mecanicos do |t|
      t.string :nombre, null: false
      t.string :apellido
      t.string :telefono
      t.string :correo
      t.references :especialidad, null: false, foreign_key: true
      t.string :estado, null: false, default: "activo"

      t.timestamps
    end
  end
end
