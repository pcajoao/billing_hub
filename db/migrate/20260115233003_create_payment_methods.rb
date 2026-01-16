class CreatePaymentMethods < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_methods do |t|
      t.string :gateway_id
      t.string :brand
      t.string :last4
      t.string :exp_month
      t.string :exp_year
      t.string :holder_name
      t.boolean :is_default, default: false
      t.references :customer, null: false, foreign_key: true
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
