class Category < ApplicationRecord
  has_and_belongs_to_many :tours
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_id"
  belongs_to :main_category, class_name: "Category", optional: true
end
