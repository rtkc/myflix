Fabricator(:review) do
  rating { Faker::Number.digit }
  review { Faker::Lorem.sentence }
end