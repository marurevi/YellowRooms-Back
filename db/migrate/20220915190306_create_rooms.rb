class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.integer :stars, null: false
      t.integer :persons_allowed, null: false
      t.string :photo, null: false
      t.text :description, null: false
      t.float :price, null: false

      t.timestamps
    end
  end
end
