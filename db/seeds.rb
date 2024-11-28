# provinces = JSON.parse(File.read(Rails.root.join('db/seeds/provinces.json')))
# provinces.each do |province|
#   Province.create!(id: province['id'], name: province['name'])
# end

# cities = JSON.parse(File.read(Rails.root.join('db/seeds/cities.json')))
# cities.each do |city|
#   City.create!(id: city['id'], name: city['name'], province_id: city['province_id'])
# end

# company_categories = JSON.parse(File.read(Rails.root.join('db/seeds/company_categories.json')))
# company_categories.each do |company_category|
#   CompanyCategory.create!(id: company_category['id'],
#     name: company_category['name'],
#     description: company_category['description'],
#     quota: company_category['quota'])
# end

# headquarters = JSON.parse(File.read(Rails.root.join('db/seeds/headquarters.json')))
# headquarters.each do |headquarter|
#   Headquarter.create!(id: headquarter['id'],
#     name: headquarter['name'],
#     description: headquarter['description'],
#     location: headquarter['location'],
#     sectional_id: headquarter['sectional_id'],
#     can_make_psychometric: headquarter['can_make_psychometric'].to_i
#   )
# end

# rooms = JSON.parse(File.read(Rails.root.join('db/seeds/rooms.json')))
# rooms.each do |room|
#   Room.create(id: room['id'],
#     name: room['name'],
#     description: room['description'],
#     headquarter_id: room['headquarter_id'],
#     capacity: room['capacity'].to_i,
#     active: room['active'].to_i
#   )
# end


# people = JSON.parse(File.read(Rails.root.join('db/seeds/people.json')))
# people.each do |person|
#   Person.create(
#     id: person['id'],
#     name: person['name'],
#     last_name: person['last_name'],
#     cuil: person['cuil'],
#     celphone: person['celphone'],
#     phone: person['phone'],
#     city_id: person['city_id'],
#     birthdate: person['birthdate'],
#     email: person['email'],
#     direction: person['direction'],
#     code: person['code']
#   )
# end

FleetCategory.create(name: "Automovil")
FleetCategory.create(name: "Camioneta 4x2")
FleetCategory.create(name: "Camioneta 4x4")

InscriptionMotive.create(name: "Nuevo ingreso")
InscriptionMotive.create(name: "Cambio de categoría")
InscriptionMotive.create(name: "Scoring")
