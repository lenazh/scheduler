class SectionChangeWeekdayToString < ActiveRecord::Migration
  def change
    change_column :sections, :weekday, :string
  end
end
