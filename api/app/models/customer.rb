class Customer < ApplicationRecord
  validates :customer_name, presence: true

  has_many :completed_orders
  belongs_to :tier

  # Update customer's current tier by customer id
  def self.update(customer_id, tier_id)
    Customer
    .find(customer_id)
    .update(tier_id: tier_id)
  end
end
