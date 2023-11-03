require "securerandom"

FactoryBot.define do
  factory :customer do
    # customer_id { SecureRandom.uuid }
    # customer_name { Faker::Name.name }

    # trait :order_completed_last_year do
    #   order_id {SecureRandom.uuid}
    #   total_in_cents { 10000 }
    #   date { Date.today.beginning_of_year.last_year }
    # end

    # trait :order_completed_current_year do
    #   order_id {SecureRandom.uuid}
    #   total_in_cents { 10000 }
    #   date { Date.Today }
    # end
  end
end
