class AddClassToSection < ActiveRecord::Migration
  def change
    add_column :sections, :class_id, :integer
  end
end
