Fabricator(:tour) do
  name {Faker::Name.title}
  description {Faker::Hipster.paragraph(5)}
  price 240
  image_url do
    Rack::Test::UploadedFile.new("spec/support/colosseo.jpg")
  end
  duration 5
  location {Faker::Address.city}
end
