class AddDeletedToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :deleted, :boolean, default: false
  end
end
