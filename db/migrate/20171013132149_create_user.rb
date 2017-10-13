class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :role
      t.string :last_login_at
      t.string :ip_address
    end
  end
end
