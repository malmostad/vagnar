class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.time :time_slot
      t.references :company, foreign_key: true
      t.references :place, foreign_key: true
      t.timestamps
    end
  end
end
