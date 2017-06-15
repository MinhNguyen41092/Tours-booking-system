class LineItem < ApplicationRecord
  belongs_to :line_itemable, polymorphic: true
end
