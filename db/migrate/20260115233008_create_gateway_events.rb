class CreateGatewayEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :gateway_events do |t|
      t.string :gateway_id
      t.string :event_type
      t.json :payload
      t.datetime :processed_at

      t.timestamps
    end
  end
end
