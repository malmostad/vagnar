class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :p_number
      t.string :name
      t.string :email
      t.string :company_name
      t.datetime :last_login_at
      t.string :ip

      t.timestamps
    end
    add_index :sellers, :p_number, unique: true
  end
end
