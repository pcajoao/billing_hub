class CreateInvoiceItems < ActiveRecord::Migration[7.1]
  def change
    create_table :invoice_items do |t|
      t.string :description
      t.integer :amount_cents
      t.integer :quantity
      t.string :item_type
      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
