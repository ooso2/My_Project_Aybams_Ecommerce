class AddUserToOrders < ActiveRecord::Migration[7.0]
  def up
    unless column_exists?(:orders, :user_id)
      add_reference :orders, :user, null: false, foreign_key: true
    end

    unless index_exists?(:orders, :user_id)
      add_index :orders, :user_id
    end

    unless foreign_key_exists?(:orders, :users)
      add_foreign_key :orders, :users
    end
  end

  def down
    remove_foreign_key :orders, :users if foreign_key_exists?(:orders, :users)
    if column_exists?(:orders, :user_id)
      remove_index :orders, :user_id if index_exists?(:orders, :user_id)
      remove_reference :orders, :user
    end
  end
end
