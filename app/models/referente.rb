class Referente < ApplicationRecord
  self.table_name = "z_referentes_empresas"

  def self.crear_managers
    Referente.all.each do |referente|
      next if Person.find_by(id: referente.idpersona).blank? # hay personas que las borraron
      manager = CompanyManager.new(
        id: referente.idreferente,
        company_id: referente.idempresa,
        person_id: referente.idpersona,
        email: referente.mail,
        job: referente.funcion,
        notifications: referente.recibenotificacion
      )
      if manager.valid?
        manager.save
      else
        debugger
      end
    end
  end
end
