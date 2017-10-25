class CreateTimeSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :time_slots do |t|
      t.string :from
      t.string :to

      t.timestamps
    end
  end
end
