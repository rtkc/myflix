Fabricator(:review) do
  rating { Faker::Number.digit }
  comment { Faker::Lorem.sentence }
end