class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :snin_birthdate
      t.string :snin_extension
      t.string :name
      t.references :company, foreign_key: true
      t.datetime :last_login_at

      t.timestamps
    end
  end
end
