class AddIdCupoEmpresaToCoursePeople < ActiveRecord::Migration[8.0]
  def change
    # esta columna la necesite porque sino perdia el id que hacia referencia a otras tablas
    add_column :course_people, :idcupoempresa, :integer, comment: "columna q agregamos para migrar datos. cuando termina se elimina"
  end
end
