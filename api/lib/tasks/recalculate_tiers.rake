# In terminal open: crontab -e
# 59 23 31 12 * /loyalty/api/bin/rake tier:recalculate RAILS_ENV=production
# This cron job runs the tier:recalculate task at the end of every December.

namespace :tier do
  desc 'Recalculate customer current tier at the end of each year'
  task :recalculate => :environment do
    Customer.all.each do |customer|
      total_spent_since_start = CompletedOrder.total_spent_since_start(customer[:id])
      total_spent_current_year = CompletedOrder.total_spent_current_year(customer[:id])
      next_year_tier =
        Tier.downgrade_tier_next_year(total_spent_since_start, total_spent_current_year)

      if !next_year_tier.nil?
        tier = Tier.find_by(name: next_year_tier)
        Customer.update(customer.id, tier[:id])
      end
    end

    puts 'Customer tier finish recalculated.'
  end
end
