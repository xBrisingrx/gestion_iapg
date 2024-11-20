provinces = JSON.parse(File.read(Rails.root.join('db/seeds/provinces.json')))
provinces.each do |province|
  Province.create!(id: province['id'], name: province['name'])
end

cities = JSON.parse(File.read(Rails.root.join('db/seeds/cities.json')))
cities.each do |city|
  City.create!(id: city['id'], name: city['name'], province_id: city['province_id'])
end

company_categories = JSON.parse(File.read(Rails.root.join('db/seeds/company_categories.json')))
company_categories.each do |company_category|
  CompanyCategory.create!(id: company_category['id'],
    name: company_category['name'],
    description: company_category['description'],
    quota: company_category['quota'])
end
