class AddFriendlyIdSlugs < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :slug_count, :integer, default: 0
    add_column :products, :slug_count, :integer, default: 0
  end
end