class AddRoomToSection < ActiveRecord::Migration
  def up
    add_column :sections, :room, :string
  end
end
