class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :name
      t.string :address
      t.integer :east
      t.integer :north
      t.boolean :active

      t.timestamps
    end
  end
end
