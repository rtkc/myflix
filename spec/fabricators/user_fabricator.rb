Fabricator(:user) do
  full_name { Faker::Name.name }
  password { Faker::Internet.password(5) }
  email { Faker::Internet.email }
end

Fabricator(:admin, from: :user) do 
  admin true
end