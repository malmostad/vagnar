class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :org_number
      t.string :police_permit
      t.date :permit_starts_at
      t.date :permit_ends_at
      t.timestamps
    end
  end
end
