class CompletedOrder < ApplicationRecord
  scope :current_year,
    -> {where(date: Date.today.beginning_of_year..Date.today.end_of_year)}

  validates :customer_id, :order_id, :total_in_cents, :date, presence: true
  belongs_to :customer

  def self.total_spent_since_start(customer_id)
    CompletedOrder
    .where(customer_id: customer_id)
    .sum(:total_in_cents)
  end

  def self.total_spent_current_year(customer_id)
    CompletedOrder
    .where(customer_id: customer_id)
    .current_year
    .sum(:total_in_cents)
  end
end
