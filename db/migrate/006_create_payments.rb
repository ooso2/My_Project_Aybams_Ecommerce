class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :payment_method
      t.string :payment_status, default: 'pending'
      t.decimal :amount, precision: 10, scale: 2
      t.string :transaction_id
      t.text :gateway_response
      t.datetime :payment_date

      t.timestamps
    end

    add_index :payments, :transaction_id, unique: true
    add_index :payments, :payment_status
  end
end