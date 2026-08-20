class CreateDiagnosticos < ActiveRecord::Migration[8.1]
  def change
    create_table :diagnosticos do |t|
      t.references :orden_trabajo, null: false, foreign_key: true, index: false
      t.date :fecha, null: false
      t.text :descripcion, null: false
      t.text :observaciones
      t.string :estado, null: false, default: "registrado"

      t.timestamps
    end
    add_index :diagnosticos, :orden_trabajo_id, unique: true
  end
end
