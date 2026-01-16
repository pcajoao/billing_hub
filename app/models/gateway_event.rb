class GatewayEvent < ApplicationRecord  
  validates :gateway_id, presence: true
  validates :payload, presence: true

  scope :unprocessed, -> { where(processed_at: nil) }
end
