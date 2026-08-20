class AddRolToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :rol, :string, null: false, default: "recepcionista"
  end
end
