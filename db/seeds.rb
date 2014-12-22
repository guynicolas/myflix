# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedies =    Category.create(name: "TV Comedies")
dramas =      Category.create(name: "TV Dramas")

futurama =    Video.create(title: 'Futurama',   description: 'Space Travel.',                   small_cover_url: '/tmp/futurama.jpg',   large_cover_url: '/tmp/monk_large.jpg', category_id: comedies.id)
family_guy =  Video.create(title: 'Family Guy', description: 'Peter Griffin and talking dog',   small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: dramas.id)
monk =        Video.create(title: 'Monk',       description: 'Paranoid SF detective',           small_cover_url: '/tmp/monk.jpg',       large_cover_url: '/tmp/monk_large.jpg', category_id: comedies.id)
south_path =  Video.create(title: 'South Park', description: 'Hippie kids',                     small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: dramas.id)