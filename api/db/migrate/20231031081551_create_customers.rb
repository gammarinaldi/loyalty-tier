class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers, id: :uuid do |t|
      t.string :customer_name

      t.timestamps
    end

    add_reference :customers, :tier, null: false, foreign_key: true, index: true, type: :uuid
  end
end
