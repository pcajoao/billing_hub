class Product < ApplicationRecord
  has_many :tenants
  has_many :subscriptions
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :api_key, presence: true, uniqueness: true
end
