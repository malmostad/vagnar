class CreateSellerAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :seller_accounts do |t|
      t.string :name
      t.belongs_to :user, index: { unique: true }, foreign_key: true
    end
  end
end
