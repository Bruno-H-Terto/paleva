class CreateMenuItems < ActiveRecord::Migration[7.2]
  def change
    create_table :menu_items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :calories
      t.references :option, polymorphic: true, null: false

      t.timestamps
    end
  end
end
