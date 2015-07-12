class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.references :user, index: true, foreign_key: true
      t.references :section, index: true, foreign_key: true
      t.integer :preference

      t.timestamps
    end
  end
end
