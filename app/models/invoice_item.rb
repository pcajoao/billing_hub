class InvoiceItem < ApplicationRecord
  belongs_to :invoice

  validates :description, presence: true
  validates :amount_cents, presence: true
  validates :quantity, presence: true

  monetize :amount_cents
end
