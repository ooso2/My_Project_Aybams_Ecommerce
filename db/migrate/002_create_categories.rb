class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.references :parent, null: true, foreign_key: { to_table: :categories }
      t.string :slug
      t.boolean :active, default: true
      t.integer :sort_order, default: 0

      t.timestamps
    end

    add_index :categories, :slug, unique: true
    add_index :categories, :active
  end
end