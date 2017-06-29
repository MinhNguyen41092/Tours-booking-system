Fabricator(:user) do
  username Faker::Name.name
  email Faker::Internet.free_email
  password "dinhminh"
  password_confirmation "dinhminh"
  avatar "minh.jpg"
  is_admin true
end
