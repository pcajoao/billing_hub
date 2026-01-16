class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :product
  belongs_to :subscription, optional: true
  has_many :invoice_items, dependent: :destroy
  has_many :transactions

  validates :total_amount_cents, presence: true

  monetize :total_amount_cents

  state_machine :status, initial: :pending do
    event :pay do
      transition [:pending, :overdue] => :paid
    end

    event :void do
      transition [:pending] => :voided
    end

    event :mark_overdue do
      transition [:pending] => :overdue
    end

    event :refund do
      transition [:paid] => :refunded
    end
  end

  def calculate_total_cents

    total_amount_cents
  end
end
