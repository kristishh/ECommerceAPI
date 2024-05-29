class CreateProductCards < ActiveRecord::Migration[7.1]
  def change
    create_table :product_cards do |t|
      t.string :activation_code, null: false
      t.string :pin_code, null: false
      t.string :status, null: false
      t.integer :quantity, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :product, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
