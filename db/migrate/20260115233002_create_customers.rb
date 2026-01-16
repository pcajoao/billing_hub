class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :doc_type
      t.string :doc_number
      t.string :external_id
      t.string :global_id, index: true
      t.string :gateway_id
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end
    add_index :customers, [:tenant_id, :external_id], unique: true
  end
end
