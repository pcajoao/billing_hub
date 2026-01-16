class PaymentMethod < ApplicationRecord
  include Discard::Model

  belongs_to :customer

  validates :gateway_id, presence: true
  validates :last4, presence: true
  validates :brand, presence: true

  scope :default, -> { where(is_default: true) }
end
