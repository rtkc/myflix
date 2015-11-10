# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Using create! would be better than create as create! throws an exception when the record is not valid. Standard create does not do that. and in seeds.rb you want to see it because you run it from command line.
Video.create!(title: "Monk", description: "Monk seed video", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: 1)
Video.create!(title: "Family Guy", description: "Family Guy seed video", small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: 1)
Video.create!(title: "Futurama", description: "Futurama seed video", small_cover_url: "/tmp/futurama.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: 1)
Video.create!(title: "Simpsons", description: "Simpsons seed video", small_cover_url: "/tmp/simpsons.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: 1)
Video.create!(title: "2 Broke Girls", description: "2 Broke Girls seed video", small_cover_url: "/tmp/2brokegirls.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: 1)
Video.create!(title: "South Park", description: "South Park seed video", small_cover_url: "/tmp/south_park.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: 1)


Video.create!(title: "Monk", description: "Monk seed video", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg", category_id: 2)

Category.create!(name: "Comedy")
Category.create!(name: "Drama")
