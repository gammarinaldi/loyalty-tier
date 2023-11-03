# In terminal open: crontab -e
# 59 23 31 12 * /loyalty/api/bin/rake current_tier:recalculate RAILS_ENV=production
# This cron job runs the tier:recalculate task at the end of every December.

namespace :current_tier do
  desc 'Recalculate customer current tier'
  task :recalculate => :environment do
    Customer.all.each do |customer|
      total_spent_since_start = CompletedOrder.total_spent_since_start(customer[:id])
      tier = Tier.find_by(name: Tier.get(total_spent_since_start).name)

      Customer.update(customer.id, tier[:id])
    end

    puts 'Customer current tier finish recalculated.'
  end
end
