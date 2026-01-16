class Subscription < ApplicationRecord
  include Discard::Model

  belongs_to :customer
  belongs_to :product
  has_many :invoices

  validates :status, presence: true
  validates :amount_cents, presence: true

  enum :status, {
    active: 'active',
    canceled: 'canceled',
    past_due: 'past_due',
    trialing: 'trialing'
  }

  monetize :amount_cents
end
