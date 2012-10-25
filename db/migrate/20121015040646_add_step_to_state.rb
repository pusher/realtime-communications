class AddStepToState < ActiveRecord::Migration
  def change
  	add_column :states, :step, :integer
  end
end
