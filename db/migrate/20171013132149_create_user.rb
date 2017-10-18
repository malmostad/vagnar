class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :role
      t.string :last_login_at

      t.timestamps
    end
    add_index :users, :username
  end
end
