class CreateAdminAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_accounts do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
