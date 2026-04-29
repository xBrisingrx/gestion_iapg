class Empresa < ApplicationRecord
  self.table_name = "z_empresas"

  def self.crear_empresas
    empresas = Empresa.all
    empresas.each do |empresa|
      province = Province.find_by(name: empresa.provincia)
      city = City.find_by(name: empresa.localidad)
      iva_condition = IvaCondition.find_by(name: empresa.condicioniva)

      company = Company.new(
        id: empresa.idempresa,
        name: empresa.razonsocial,
        cuit: empresa.cuit,
        direction: empresa.domicilio,
        phone: empresa.telefono,
        operator: empresa.operadora,
        comment: empresa.observaciones,
        iva_condition_id: (iva_condition.blank?) ? nil : iva_condition.id,
        company_category_id: empresa.idcategoriaempresa,
        province_id: (province.blank?) ? nil : province.id,
        city_id: (city.blank?) ? nil : city.id,
        credential_years: 2
      )
      if company.valid?
        company.save
      else
        degugger
      end
    end
  end

  def self.acomodar_data
    Empresa.where(provincia: "Bs.As").update_all(provincia: "Buenos Aires")
    Empresa.where(provincia: "Bs As").update_all(provincia: "Buenos Aires")
    Empresa.where(provincia: "Bs. As").update_all(provincia: "Buenos Aires")
    Empresa.where(provincia: "TDF").update_all(provincia: "Tierra del Fuego")
    Empresa.where(provincia: "Santa Fé").update_all(provincia: "Santa Fe")
    Empresa.where(localidad: "Ciudad Autonoma Buenos Aires").update_all(provincia: "Buenos Aires")
    Empresa.where(localidad: "Comodoro Rivadavia").update_all(provincia: "Chubut")
    Empresa.where(telefono: "Santa Cruz").update_all(provincia: "Santa Cruz")
    Empresa.where(provincia: "Caleta Olivia").update_all(provincia: "Santa Cruz", localidad: "Caleta Olivia")
  end
end
