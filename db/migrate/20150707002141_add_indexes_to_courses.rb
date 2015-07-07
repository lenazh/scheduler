class AddIndexesToCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :user_id, :integer
    change_table :courses do |t|
      t.references :user, index: true, foreign_key: true
    end
  end
end
