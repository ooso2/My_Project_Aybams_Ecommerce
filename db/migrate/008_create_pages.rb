class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content
      t.text :meta_description
      t.boolean :published, default: true
      t.integer :sort_order, default: 0

      t.timestamps
    end

    add_index :pages, :slug, unique: true
    add_index :pages, :published
  end
end