class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true
      t.integer :hours_per_week

      t.timestamps
    end
  end
end

