class CreateSeller < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :ssn
      t.string :name
      t.string :company
      t.datetime :last_login_at
    end
    add_index :sellers, :ssn
  end
end
