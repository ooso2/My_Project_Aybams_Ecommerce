class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :current_price
      t.integer :stock_quantity
      t.references :category, null: false, foreign_key: true
      t.string :sku
      t.decimal :weight
      t.string :dimensions
      t.boolean :is_active

      t.timestamps
    end
  end
end
