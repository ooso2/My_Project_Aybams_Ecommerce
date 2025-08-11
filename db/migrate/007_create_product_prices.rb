class CreateProductPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :product_prices do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.boolean :is_active, default: true
      t.string :reason # sale, promotion, cost_change, etc.

      t.timestamps
    end

    add_index :product_prices, [:product_id, :start_date]
    add_index :product_prices, :is_active
  end
end