class CreateFinancialReports < ActiveRecord::Migration[5.0]
  def change
    create_table :financial_reports do |t|
      t.integer :user_id
      t.date :date
      t.decimal :cost
      t.decimal :revenue
      t.decimal :net_income

      t.timestamps
    end
  end
end
