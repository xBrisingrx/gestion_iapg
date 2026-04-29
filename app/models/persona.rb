class Persona < ApplicationRecord
  self.table_name = "z_personas"

  def self.crear_personas
    personas = Persona.all
    personas.each do |persona|
      city = City.find_by(id: persona.idlocalidad)
      person = Person.new(
        id: persona.idpersona,
        cuil: persona.cuil,
        last_name: persona.apellido,
        name: persona.nombre,
        birthdate: (persona.fechanacimiento.blank?) ? "1976-06-01" : persona.fechanacimiento,
        phone: (persona.telefono.blank?) ? "Sin telefono" : persona.telefono,
        celphone: (persona.nrocelular.blank?) ? "Sin celular" : persona.nrocelular,
        email: (persona.mail.blank?) ? "email@sindireccion.com" : persona.mail,
        direction: (persona.domicilio.blank?) ? "Sin direccion" : persona.domicilio,
        code: persona.code,
        province_id: (city.blank?) ? nil : city.province.id,
        city_id: (city.blank?) ? nil : city.id
      )
      if person.valid?
        person.save
      else
        debugger
      end
    end # each personas
  end # metodo crear_personas

  def self.acomodar_data
    Persona.find(1279).update(mail: "administracion@xerexservicios.com")
  end
end
