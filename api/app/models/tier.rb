class Tier < ApplicationRecord
  validates :name, :minimum_spent_cents, presence: true
  has_many :customers

  # Get current tier by total spent cents
  def self.get(total_spent)
    current_tier = nil

    Tier
    .all
    .order("minimum_spent_cents DESC")
    .map do |tier|
      if total_spent >= tier.minimum_spent_cents
        current_tier = tier

        break
      end
    end

    current_tier
  end

  # Calculate amount that must be spent in order to reach the next tier
  def self.amount_to_next_tier(total_spent)
    next_tier_minimum =
      Tier
      .where('minimum_spent_cents > ?', total_spent)
      .order(:minimum_spent_cents)
      .first

    if next_tier_minimum.nil?
      0
    else
      next_tier_minimum.minimum_spent_cents - total_spent
    end
  end

  # Calculate tier the customer will be downgraded to next year
  def self.downgrade_tier_next_year(total_spent_since_start, total_spent_current_year)
    current_tier = get(total_spent_since_start).name
    next_tier = get(total_spent_current_year).name

    if current_tier == next_tier
      nil
    else
      next_tier
    end
  end

  def self.amount_to_maintain_tier(total_spent_since_start, total_spent_current_year)
    current_tier_minimum_spent = get(total_spent_since_start).minimum_spent_cents

    if total_spent_current_year >= current_tier_minimum_spent
      0
    else
      current_tier_minimum_spent - total_spent_current_year
    end

  end
end
