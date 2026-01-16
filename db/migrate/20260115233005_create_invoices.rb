class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.string :status
      t.datetime :due_date
      t.integer :total_amount_cents
      t.string :gateway_id
      t.string :checkout_url
      t.references :customer, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :subscription, null: true, foreign_key: true

      t.timestamps
    end
  end
end
