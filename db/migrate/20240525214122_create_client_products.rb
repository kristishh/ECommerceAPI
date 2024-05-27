class CreateClientProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :client_products do |t|
      t.references :user, index: true
      t.references :product, index: true

      t.timestamps
    end

    # add_index :client_products, [:user_id, :product_id]
  end
end
