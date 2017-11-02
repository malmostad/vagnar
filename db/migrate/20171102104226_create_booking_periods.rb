class CreateBookingPeriods < ActiveRecord::Migration[5.1]
  def change
    create_table :booking_periods do |t|
      t.date :starts_at
      t.date :ends_at
      t.date :booking_starts_at
      t.date :booking_ends_at

      t.timestamps
    end
  end
end
