class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :email
      t.string :phone_number
      t.integer :status
      t.decimal :total_cost

      t.timestamps
    end
  end
end
