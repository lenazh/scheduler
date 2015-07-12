class SectionStartEndTimestapmsToHoursAndMinutes < ActiveRecord::Migration
  def change
    remove_column :sections, :start_time, :timestamp
    remove_column :sections, :end_time, :timestamp
    add_column :sections, :start_hour, :integer, {limit: 1}
    add_column :sections, :start_minute, :integer, {limit: 1}
    add_column :sections, :duration_hours, :integer, {limit: 1}
  end
end
