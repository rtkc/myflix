Fabricator(:categories) do
  name { "Comedy"}
  user { Fabricate(:user) }
end