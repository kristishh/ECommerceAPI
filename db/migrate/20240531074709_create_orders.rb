class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :product_card, index: true, foreign_key: true, null: false
      t.string :status, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
