module CustomerHelpers
  def tiers
    tiers_name = ['Bronze', 'Silver', 'Gold']
    minimum_spent_cents = [0, 10000, 50000]

    tiers = FactoryBot.build_list(:tier, 3) do |tier, i|
      tier.name = tiers_name[i]
      tier.minimum_spent_cents = minimum_spent_cents[i]
      tier.save!
    end
  end

  def customer
    FactoryBot.create(:customer, customer_name: Faker::Name.name, tier_id: tiers[0].id)
  end

  def date
    Faker::Date.between(
            from: Date.today.beginning_of_year,
            to: Date.today.end_of_year
          )
  end

  def total_in_cents
    Faker::Number.between(from: 1000, to: 50000)
  end
end
