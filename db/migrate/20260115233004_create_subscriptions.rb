class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :plan_id
      t.string :status
      t.datetime :current_period_end
      t.string :gateway_id
      t.integer :amount_cents
      t.string :cron_expression
      t.references :customer, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
