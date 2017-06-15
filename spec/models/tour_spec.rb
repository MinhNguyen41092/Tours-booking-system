require 'rails_helper'

RSpec.describe Tour, type: :model do
  describe "relationships" do
    it {should have_many(:reviews)}
    it {should have_and_belong_to_many(:categories)}
  end

  describe "valications" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:description)}
    it {should validate_presence_of(:price)}
    it {should validate_presence_of(:image_url)}
    it {should validate_presence_of(:duration)}
    it {should validate_presence_of(:location)}
    it {should validate_length_of(:name).is_at_least(10)}
    it {should validate_length_of(:name).is_at_most(150)}
    it {should validate_length_of(:description).is_at_least(150)}
    it {should validate_length_of(:description).is_at_most(500)}
  end
end
