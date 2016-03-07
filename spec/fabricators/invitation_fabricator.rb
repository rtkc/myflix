Fabricator(:invitation) do
  recipient_email { Faker::Internet.email }
  recipient_name { Faker::Name.name }
  inviter { Fabricate(:user) }
  message { Faker::Lorem.sentence }
end