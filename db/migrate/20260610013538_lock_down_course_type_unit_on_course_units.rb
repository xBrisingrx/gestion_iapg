class LockDownCourseTypeUnitOnCourseUnits < ActiveRecord::Migration[8.0]
  def up
    # Verificación final por si quedó algún huérfano sin que te avisen.
    unmatched = CourseUnit.where(course_type_unit_id: nil).count
    raise "Hay #{unmatched} course_units sin course_type_unit_id — corré la backfill" if unmatched > 0

    # NOT NULL
    change_column_null :course_units, :course_type_unit_id, false

    # Foreign key con restrict: no se puede borrar un CourseTypeUnit
    # si hay CourseUnits que lo referencian.
    add_foreign_key :course_units, :course_type_units, on_delete: :restrict
  end

  def down
    remove_foreign_key :course_units, :course_type_units
    change_column_null :course_units, :course_type_unit_id, true
  end
end
