class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :city, null: false

      t.timestamps
    end
  end
end
