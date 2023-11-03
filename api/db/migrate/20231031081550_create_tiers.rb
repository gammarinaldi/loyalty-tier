class CreateTiers < ActiveRecord::Migration[7.1]
  def change
    create_table :tiers, id: :uuid do |t|
      t.string :name, null: false
      t.integer :minimum_spent_cents, null: false

      t.timestamps
    end
  end
end
