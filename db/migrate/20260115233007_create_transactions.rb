class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :gateway_id
      t.string :status
      t.string :kind
      t.integer :amount_cents
      t.string :gateway_response_code
      t.text :gateway_response_message
      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
