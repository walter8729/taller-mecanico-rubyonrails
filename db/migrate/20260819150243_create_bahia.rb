class CreateBahia < ActiveRecord::Migration[8.1]
  def change
    create_table :bahias do |t|
      t.integer :numero, null: false
      t.string :tipo, null: false, default: "elevador"
      t.string :estado, null: false, default: "disponible"

      t.timestamps
    end
    add_index :bahias, :numero, unique: true
  end
end
