class CreateTenants < ActiveRecord::Migration[7.1]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :external_id
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tenants, [:product_id, :external_id], unique: true
  end
end
