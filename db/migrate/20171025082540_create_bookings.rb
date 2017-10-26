class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.references :time_slot, foreign_key: true
      t.references :company, foreign_key: true
      t.references :place, foreign_key: true
      t.date :date
      t.timestamps
    end
  end
end
