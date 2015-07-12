class SectionDurationToDecimal < ActiveRecord::Migration
  def change
    remove_column :sections, :duration_hours, :integer
    add_column :sections, :duration_hours, :decimal, precision: 6, scale: 3 
  end
end
