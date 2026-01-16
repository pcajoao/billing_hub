class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :code, index: { unique: true }
      t.string :api_key, index: { unique: true }
      t.string :webhook_url

      t.timestamps
    end
  end
end
