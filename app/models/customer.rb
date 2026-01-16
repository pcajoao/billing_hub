class Customer < ApplicationRecord
  belongs_to :tenant
  has_many :payment_methods
  has_many :subscriptions
  has_many :invoices

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :global_id, uniqueness: true, allow_nil: true
  validates :doc_number, presence: true

  def default_payment_method
    payment_methods.find_by(is_default: true)
  end
end
