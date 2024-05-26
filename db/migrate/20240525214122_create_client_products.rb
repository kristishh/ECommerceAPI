class CreateClientProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :client_products do |t|
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end

    add_index :client_products, [:user_id, :product_id]
  end
end
