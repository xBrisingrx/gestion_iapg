class AddDefaultValueToScoringToCoursePerson < ActiveRecord::Migration[8.0]
  def change
    change_column_default :course_people, :scoring, from: nil, to: 0
    change_column_default :course_people, :make_up_1, from: nil, to: 0
    change_column_default :course_people, :make_up_2, from: nil, to: 0
  end
end
