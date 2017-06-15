class CreateCategoriesTours < ActiveRecord::Migration[5.0]
  def change
    create_table :categories_tours, id: false do |t|
      t.integer :category_id
      t.integer :tour_id
    end
  end
end
