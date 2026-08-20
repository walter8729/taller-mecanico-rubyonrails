class CreateEspecialidades < ActiveRecord::Migration[8.1]
  def change
    create_table :especialidades do |t|
      t.string :nombre, null: false
      t.text :descripcion
      t.string :estado, null: false, default: "activo"

      t.timestamps
    end
  end
end
