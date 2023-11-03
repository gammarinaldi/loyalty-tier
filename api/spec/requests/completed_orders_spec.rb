require 'rails_helper'
require 'securerandom'

RSpec.describe "Completed Orders", type: :request do
  let!(:completed_orders) {
    FactoryBot.create_list(
      :completed_order,
      5,
      customer_id: customer.id,
      order_id: SecureRandom.uuid,
      total_in_cents: total_in_cents,
      date: date
    )
  }

  describe "GET /completed_orders" do
    before do
      get '/api/v1/completed_orders', headers: headers
    end

    it 'returns http status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all completed orders' do
      expect(json[:data].size).to eq(5)
    end
  end

  describe "POST /completed_orders" do
    context 'with valid parameters' do
      before do
        params = {
          customerId: customer.id,
          orderId: SecureRandom.uuid,
          totalInCents: total_in_cents,
          date: date
        }

        post '/api/v1/completed_orders', headers: headers, params: params, as: :json
      end

      it 'returns http status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success response' do
        expect(json[:status]).to eq("Success")
      end

      it 'returns completed_order_id' do
        expect(json[:data][:orderId]).not_to be_nil
      end
    end

    context 'with invalid parameters' do
      before do
        params = {
          customerId: customer.id,
          orderId: '',
          totalInCents: '',
          date: ''
        }

        post '/api/v1/completed_orders', headers: headers, params: params, as: :json
      end

      it 'returns error status' do
        expect(response).to have_http_status(:internal_server_error)
      end
    end

    context 'with non-exist customer' do
      before do
        params = {
          customerId: nil
        }

        post '/api/v1/completed_orders', headers: headers, params: params, as: :json
      end

      it 'returns http status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns error response' do
        expect(json[:status]).to eq("Error")
      end

      it 'returns error message' do
        expect(json[:data]).to eq("Customer not found")
      end
    end
  end
end
