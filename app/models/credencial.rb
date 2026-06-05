class Credencial < ApplicationRecord
  self.table_name = "z_credenciales_final"

  def self.imagenes_personas
    credenciales = Credencial.select(:id, :imagen, :idpersona).where("imagen != ?", "").group(:imagen).order(:id)
    credenciales.each do |credencial|
      person = Person.find_by(id: credencial.idpersona)
      base_dir = "/home/mauro/Documentos/iapg/imagenes"
      file_dir = "#{base_dir}/#{credencial.imagen}"
      if File.exist?(file_dir) && !person.blank?
        person.images.attach(io: File.open(file_dir), filename: credencial.imagen)
        puts file_dir
        sleep 1
      else
        puts "#{credencial.idpersona} --- #{credencial.imagen}"
      end
    end
  end
end
