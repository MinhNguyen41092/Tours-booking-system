class CreateTours < ActiveRecord::Migration[5.0]
  def change
    create_table :tours do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :image_url
      t.integer :duration
      t.string :location

      t.timestamps
    end
  end
end
