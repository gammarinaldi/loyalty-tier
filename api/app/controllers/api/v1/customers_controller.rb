class Api::V1::CustomersController < ApplicationController
  # GET /customers/:page
  def index
    customers = Customer.all.order("customer_name ASC")

    if customers.present?
      paginated_customers =
        customers
        .then(&paginate)
        .map do |customer|
          {
            customerId: customer.id,
            customerName: customer.customer_name,
            tier: customer.tier.name
          }
        end

      metadata = {
        totalItems: customers.size,
        totalPages: (customers.size.to_f / 5.to_f).ceil,
        currentPage: params[:page]&.to_i || 1
      }

      render json: {status: "Success", data: paginated_customers, metadata: metadata}
    elsif customers.empty?
      render json: {status: "Success", data: "Data is empty."}
    else
      render json: {errors: customers.errors}, status: 500
    end
  end

  # GET /customers/:customer_id
  def show
    customer = Customer.find_by(id: params[:id])

    case customer
    when Customer
      total_spent_since_start = CompletedOrder.total_spent_since_start(customer[:id])
      total_spent_current_year = CompletedOrder.total_spent_current_year(customer[:id])

      first_completed_order =
        CompletedOrder
        .select(:date)
        .where(customer_id: customer[:id])
        .order("date ASC")
        .first

      amount_to_next_tier = Tier.amount_to_next_tier(total_spent_since_start)

      next_year_downgrade_tier =
        Tier.downgrade_tier_next_year(total_spent_since_start, total_spent_current_year)

      amount_to_maintain_tier =
        Tier.amount_to_maintain_tier(total_spent_since_start, total_spent_current_year)

      data = {
        customerName: customer.customer_name,
        currentTier: Tier.get(total_spent_since_start).name,
        startDateTierCalculation: first_completed_order.date.to_date,
        amountSpentSinceStartDate: total_spent_since_start,
        amountToNextTier: amount_to_next_tier,
        nextTierToReach: Tier.get(total_spent_since_start + amount_to_next_tier).name,
        nextYearDowngradeTier: next_year_downgrade_tier,
        downgradeDate: Date.today.end_of_year,
        amountToMaintainTier: amount_to_maintain_tier
      }

      render json: {status: "Success", data: data}
    when nil
      render json: {status: "Error", data: "Customer not found"}, status: 404
    else
      render json: { errors: customer.errors }, status: 500
    end
  end
end
