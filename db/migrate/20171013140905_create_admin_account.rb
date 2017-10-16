class CreateAdminAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_accounts do |t|
      t.belongs_to :user, index: { unique: true }, foreign_key: true
    end
  end
end
