class CreateCompletedOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :completed_orders, id: :uuid do |t|
      t.string :order_id, null: false
      t.integer :total_in_cents, null: false, default: 0
      t.datetime :date, null: false

      t.timestamps
    end

    add_reference :completed_orders, :customer, null: false, foreign_key: true, index: true, type: :uuid
    add_index :completed_orders, :order_id
  end
end
