class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, null: false, scale: 2, precision: 10
      t.integer :status, null: false
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
