class PreferencesPreferenceToDecimal < ActiveRecord::Migration
  def change
    remove_column :preferences, :preference, :integer
    add_column :preferences, :preference, :decimal, precision: 6, scale: 3 
  end
end
