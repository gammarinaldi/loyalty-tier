require 'rails_helper'
require 'securerandom'

RSpec.describe Customer, type: :model do
  it { should validate_presence_of(:customer_name) }

  describe 'Associations' do
    it { should have_many(:completed_orders) }
    it { should belong_to(:tier) }
  end
end
