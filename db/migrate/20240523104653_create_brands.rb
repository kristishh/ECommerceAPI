class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.text :description
      t.integer :status

      t.timestamps
    end
  end
end
