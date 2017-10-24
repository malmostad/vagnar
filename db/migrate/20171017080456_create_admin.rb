class CreateAdmin < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :username
      t.datetime :last_login_at
    end
    add_index :admins, :username
  end
end
