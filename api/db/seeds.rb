# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
require 'securerandom'

# Create tiers with minimum spending amounts
[
  {name: 'Bronze', minimum_spent_cents: 0},
  {name: 'Silver', minimum_spent_cents: 10000}, # 100 dollars in cents
  {name: 'Gold', minimum_spent_cents: 50000} # 500 dollars in cents
]
.each do |tier|
  Tier.find_or_create_by!(
    name: tier[:name],
    minimum_spent_cents: tier[:minimum_spent_cents]
  )
end

puts 'Tier seed data created successfully!'

# Create dummy data for customers with completed orders
tier_id = Tier.find_by(name: 'Bronze').id

30.times.each do |_|
  customer = Customer.find_or_create_by!(
    customer_name: Faker::Name.name,
    tier_id: tier_id
  )

  1..5.times.each do |_|
    CompletedOrder.create(
      customer_id: customer.id,
      order_id: SecureRandom.uuid,
      total_in_cents: Faker::Number.between(from: 100, to: 10000),
      date: Faker::Date.between(
        from: Date.today.last_year.beginning_of_year,
        to: Date.today.end_of_year
      )
    )
  end
end

puts 'Customer and completed orders dummy seed data created successfully!'
