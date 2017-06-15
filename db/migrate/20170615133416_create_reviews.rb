class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :tour_id
      t.string :title
      t.text :body
      t.boolean :is_accepted

      t.timestamps
    end
  end
end
