class CreateSections < ActiveRecord::Migration
  def up
    create_table :sections do |t|
      t.string :name
      t.integer :lecture_id
      t.time :start_time
      t.time :end_time
      t.integer :gsi_id
      t.integer :weekday

      t.timestamps
    end
  end
end
