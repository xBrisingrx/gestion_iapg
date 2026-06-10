class AddCourseTypeUnitToCourseUnits < ActiveRecord::Migration[8.0]
  def change
    # null: true por ahora — backfilleamos en el paso siguiente.
    # foreign_key: false acá: lo agregamos después de la backfill para no fallar.
    add_reference :course_units, :course_type_unit,
                  null: true,
                  foreign_key: false,
                  index: true
  end
  # Esto es idempotente y seguro: agrega columna nullable, sin constraint todavía. Ningún código existente se rompe porque la columna existe pero nadie la usa.
end
