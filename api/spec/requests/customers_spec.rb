require 'rails_helper'
require 'securerandom'

RSpec.describe "Customers", type: :request do
  describe "GET /customers" do
    before do
      5.times.each do |customer|
        customer
      end

      get '/api/v1/customers', headers: headers
    end

    it 'returns http status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all customers' do
      expect(json[:data].size).to eq(5)
    end
  end

  describe "GET /customers/:customer_id" do
    context 'with valid parameter' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 0,
          date: Date.parse("02/02/2022")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'returns http status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns current tier' do
        expect(json[:data][:currentTier]).to eq('Bronze')
      end
    end

    context 'with invalid parameter' do
      before do
        get "/api/v1/customers/1", headers: headers
      end

      it 'returns http status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns error customer not found' do
        expect(json[:data]).to eq('Customer not found')
      end
    end
  end

  describe "Calculate customer's tier" do
    context 'spent < $100 since start of last year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 1000,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 1000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'tier is Bronze' do
        expect(json[:data][:currentTier]).to eq('Bronze')
      end
    end

    context 'spent >= $100 and < $500 since start of last year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 5000,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 5000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'tier is Silver' do
        expect(json[:data][:currentTier]).to eq('Silver')
      end
    end

    context 'spent >= $500 since start of last year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 25000,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 25000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'tier is Gold' do
        expect(json[:data][:currentTier]).to eq('Gold')
      end
    end

    context 'spent zero in current year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 50000,
          date: Date.parse("12/12/2022")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'tier downgraded to Bronze' do
        expect(json[:data][:nextYearDowngradeTier]).to eq('Bronze')
      end

      it 'amount to maintain tier is 50000' do
        expect(json[:data][:amountToMaintainTier]).to eq(50000)
      end
    end

    context 'spent < $ 100 in current year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 50000,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 9000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'tier downgraded to Bronze' do
        expect(json[:data][:nextYearDowngradeTier]).to eq('Bronze')
      end

      it 'amount to maintain tier is 41000' do
        expect(json[:data][:amountToMaintainTier]).to eq(41000)
      end
    end

    context 'Gold tier spent < $ 500 in current year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 50000,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 40000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'tier downgraded to Silver' do
        expect(json[:data][:nextYearDowngradeTier]).to eq('Silver')
      end

      it 'amount to maintain tier is 10000' do
        expect(json[:data][:amountToMaintainTier]).to eq(10000)
      end
    end

    context 'Silver tier spent >= $ 100 in current year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 10000,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 10000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'returns null, tier still at Silver' do
        expect(json[:data][:nextYearDowngradeTier]).to eq(nil)
      end

      it 'amount to maintain tier is zero' do
        expect(json[:data][:amountToMaintainTier]).to eq(0)
      end
    end

    context 'Gold tier spent >= $ 500 in current year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 50000,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 50000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'returns null, tier still at Gold' do
        expect(json[:data][:nextYearDowngradeTier]).to eq(nil)
      end

      it 'amount to maintain tier is zero' do
        expect(json[:data][:amountToMaintainTier]).to eq(0)
      end
    end

    context 'Bronze tier spent >= $ 100 in current year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 0,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 10000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'tier upgraded to Silver' do
        expect(json[:data][:currentTier]).to eq('Silver')
      end

      it 'amount to maintain tier is zero' do
        expect(json[:data][:amountToMaintainTier]).to eq(0)
      end
    end

    context 'Silver tier spent >= $ 500 in current year' do
      before do
        new_customer = customer
        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 10000,
          date: Date.parse("12/12/2022")
        )

        FactoryBot.create(
          :completed_order,
          customer_id: new_customer.id,
          order_id: SecureRandom.uuid,
          total_in_cents: 50000,
          date: Date.parse("03/03/2023")
        )

        get "/api/v1/customers/#{new_customer.id}", headers: headers
      end

      it 'tier upgraded to Gold' do
        expect(json[:data][:currentTier]).to eq('Gold')
      end

      it 'amount to maintain tier is zero' do
        expect(json[:data][:amountToMaintainTier]).to eq(0)
      end
    end
  end
end
