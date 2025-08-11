class AddBillingAttributesToOrders < ActiveRecord::Migration[7.0]
  def change
    # Add billing attributes only if they don't exist
    unless column_exists?(:orders, :billing_first_name)
      add_column :orders, :billing_first_name, :string
    end
    
    unless column_exists?(:orders, :billing_last_name)
      add_column :orders, :billing_last_name, :string
    end
    
    unless column_exists?(:orders, :billing_address)
      add_column :orders, :billing_address, :string
    end
    
    unless column_exists?(:orders, :billing_city)
      add_column :orders, :billing_city, :string
    end
    
    unless column_exists?(:orders, :billing_province)
      add_column :orders, :billing_province, :string
    end
    
    unless column_exists?(:orders, :billing_postal_code)
      add_column :orders, :billing_postal_code, :string
    end
  end
end