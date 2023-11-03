require "test_helper"

class CompletedOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @completed_order = completed_orders(:one)
  end

  test "should get index" do
    get completed_orders_url, as: :json
    assert_response :success
  end

  test "should create completed_order" do
    assert_difference("Order.count") do
      post completed_orders_url, params: { completed_order: { customer_id: @completed_order.customer_id, order_id: @completed_order.order_id, total_in_cents: @completed_order.total_in_cents } }, as: :json
    end

    assert_response :created
  end

  test "should show completed_order" do
    get order_url(@completed_order), as: :json
    assert_response :success
  end

  test "should update completed_order" do
    patch order_url(@completed_order), params: { completed_order: { customer_id: @completed_order.customer_id, order_id: @completed_order.order_id, total_in_cents: @completed_order.total_in_cents } }, as: :json
    assert_response :success
  end

  test "should destroy completed_order" do
    assert_difference("Order.count", -1) do
      delete order_url(@completed_order), as: :json
    end

    assert_response :no_content
  end
end
