class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :order_number, null: false
      t.datetime :order_date, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :status, default: 'pending'
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :tax_amount, precision: 10, scale: 2
      t.decimal :shipping_cost, precision: 10, scale: 2
      t.decimal :total_amount, precision: 10, scale: 2

      # Shipping Address
      t.string :shipping_first_name
      t.string :shipping_last_name
      t.string :shipping_address
      t.string :shipping_city
      t.string :shipping_province
      t.string :shipping_postal_code
      t.string :shipping_country
      t.string :shipping_phone

      # Billing Address
      t.string :billing_first_name
      t.string :billing_last_name
      t.string :billing_address
      t.string :billing_city
      t.string :billing_province
      t.string :billing_postal_code
      t.string :billing_country
      t.string :billing_phone

      t.text :notes

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
    add_index :orders, :status
    add_index :orders, :order_date
  end
end
