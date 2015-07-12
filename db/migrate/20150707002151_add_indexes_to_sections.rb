class AddIndexesToSections < ActiveRecord::Migration
  def change
    remove_column :sections, :class_id, :integer
    remove_column :sections, :gsi_id, :integer
    remove_column :sections, :lecture_id, :integer
    change_table :sections do |t|
      t.references :course, index: true, foreign_key: true
      t.references :gsi, index: true, foreign_key: true
      t.string :lecture
    end
  end
end
