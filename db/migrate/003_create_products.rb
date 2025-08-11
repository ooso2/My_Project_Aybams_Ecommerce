class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.text :short_description
      t.decimal :current_price, precision: 10, scale: 2
      t.decimal :compare_at_price, precision: 10, scale: 2
      t.integer :stock_quantity, default: 0
      t.references :category, null: false, foreign_key: true
      t.string :sku, null: false
      t.decimal :weight, precision: 8, scale: 3
      t.string :dimensions
      t.boolean :is_active, default: true
      t.boolean :featured, default: false
      t.boolean :on_sale, default: false
      t.datetime :sale_start_date
      t.datetime :sale_end_date
      t.string :slug
      t.text :sustainability_info
      t.string :material
      t.string :origin_country

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, :slug, unique: true
    add_index :products, :is_active
    add_index :products, :featured
    add_index :products, :on_sale
  end
end
