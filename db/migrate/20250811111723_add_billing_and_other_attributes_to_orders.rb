class AddBillingAndOtherAttributesToOrders < ActiveRecord::Migration[7.0]
  def change
    # Add only columns that don't exist
    add_column :orders, :billing_country, :string unless column_exists?(:orders, :billing_country)
    add_column :orders, :billing_phone, :string unless column_exists?(:orders, :billing_phone)
    add_column :orders, :shipping_country, :string unless column_exists?(:orders, :shipping_country)
    add_column :orders, :shipping_phone, :string unless column_exists?(:orders, :shipping_phone)
    add_column :orders, :notes, :text unless column_exists?(:orders, :notes)
    
    # Add order_date with default value
    unless column_exists?(:orders, :order_date)
      add_column :orders, :order_date, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
    end
    
    # Remove duplicate columns that were causing errors
    remove_column :orders, :billing_first_name if column_exists?(:orders, :billing_first_name)
    remove_column :orders, :billing_last_name if column_exists?(:orders, :billing_last_name)
    remove_column :orders, :billing_address if column_exists?(:orders, :billing_address)
    remove_column :orders, :billing_city if column_exists?(:orders, :billing_city)
    remove_column :orders, :billing_province if column_exists?(:orders, :billing_province)
    remove_column :orders, :billing_postal_code if column_exists?(:orders, :billing_postal_code)
  end
end