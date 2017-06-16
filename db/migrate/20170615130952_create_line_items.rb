class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.integer :tour_id
      t.references :line_itemable, polymorphic: true, index: true
      t.decimal :price
      t.integer :travelers
      t.string :traveler_name
      t.date :start_date

      t.timestamps
    end
  end
end
