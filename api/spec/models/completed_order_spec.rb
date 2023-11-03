require 'rails_helper'

RSpec.describe CompletedOrder, type: :model do
  it { should validate_presence_of(:customer_id) }
  it { should validate_presence_of(:order_id) }
  it { should validate_presence_of(:total_in_cents) }
  it { should validate_presence_of(:date) }

  describe 'Associations' do
    it { should belong_to(:customer) }
  end
end
