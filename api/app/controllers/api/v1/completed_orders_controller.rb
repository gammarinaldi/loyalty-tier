class Api::V1::CompletedOrdersController < ApplicationController
  # GET /completed_orders/:page
  def index
    completed_orders = CompletedOrder.all.order("date ASC")

    if completed_orders.present?
      paginated_orders =
        completed_orders
        .then(&paginate)
        .map do |order|
          {
            customerId: order.customer_id,
            customerName: order.customer.customer_name,
            orderId: order.order_id,
            date: order.date.to_date,
            totalInCents: order.total_in_cents
          }
        end

      metadata = {
        totalItems: completed_orders.size,
        totalPages: (completed_orders.size.to_f / 10.to_f).ceil,
        currentPage: params[:page]&.to_i || 1
      }

      render json: {status: "Success", data: paginated_orders, metadata: metadata}
    elsif completed_orders.empty?
      render json: {status: "Success", data: "Data is empty."}
    else
      render json: {errors: completed_orders.errors}, status: 500
    end
  end

  # GET /completed_orders/:corder_id
  def show
    order = CompletedOrder.find_by(order_id: params[:id])

    case order
    when CompletedOrder
      data = {
          orderId: order.order_id,
          totalInCents: order.total_in_cents,
          date: order.date,
          customerName: order.customer.customer_name
        }

      render json: {status: "Success", data: data}
    when nil
      render json: {status: "Error", data: "Order not found"}, status: 404
    else
      render json: {errors: order.errors}, status: 500
    end
  end

  # POST /completed_orders
  def create
    customer = Customer.find_by(id: create_params[:customer_id])

    if customer.nil?
      render json: {status: "Error", data: "Customer not found"}, status: 404
    else
      completed_order = CompletedOrder.new(create_params)

      if completed_order.save
        # Update customer's current tier
        total_spent = CompletedOrder.total_spent_since_start(completed_order[:customer_id])
        current_tier = Tier.get(total_spent)
        Customer.update(completed_order[:customer_id], current_tier[:id])

        data = {
          orderId: completed_order.order_id,
          totalInCents: completed_order.total_in_cents,
          date: completed_order.date,
          customerName: completed_order.customer.customer_name
        }

        render json: {status: "Success", data: data}
      else
        render json: {errors: completed_order.errors}, status: 500
      end
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def create_params
      res = JSON.parse(request.body.read())
      params = ActionController::Parameters.new(
        completed_order: {
          customer_id: res["customerId"],
          order_id: res["orderId"],
          total_in_cents: res["totalInCents"],
          date: res["date"]
        }
      )

      params.require(:completed_order)
      .permit(:customer_id, :order_id, :total_in_cents, :date)
    end
end
