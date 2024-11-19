provinces = JSON.parse(File.read(Rails.root.join('db/seeds/provinces.json')))
cities = JSON.parse(File.read(Rails.root.join('db/seeds/cities.json')))

provinces.each do |province|
  Province.create(id: province['id'], name: province['name'])
end

cities.each do |city|
  City.create(id: city['id'], name: city['name'], province_id: city['province_id'])
end
