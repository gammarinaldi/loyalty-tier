require 'rails_helper'

RSpec.describe Tier, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:minimum_spent_cents) }

  describe 'Associations' do
    it { should have_many(:customers) }
  end
end
