class Transaction < ApplicationRecord
  belongs_to :invoice
  
  validates :amount_cents, presence: true
  validates :gateway_id, presence: true

  monetize :amount_cents

  enum :status, {
    processing: 'processing',
    authorized: 'authorized',
    paid: 'paid',
    refunded: 'refunded',
    refused: 'refused',
    error: 'error'
  }
end
