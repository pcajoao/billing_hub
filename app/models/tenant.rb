class Tenant < ApplicationRecord
  belongs_to :product
  has_many :customers

  validates :name, presence: true
  validates :external_id, presence: true
end
