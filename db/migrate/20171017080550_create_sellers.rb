class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :snin
      t.string :name
      t.references :company, foreign_key: true
      t.datetime :last_login_at

      t.timestamps
    end
    add_index :sellers, :snin
  end
end
