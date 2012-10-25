class AddEventNameToState < ActiveRecord::Migration
  def self.up
  	add_column :states, :event_name, :string
  end

  def self.down
  end
end
