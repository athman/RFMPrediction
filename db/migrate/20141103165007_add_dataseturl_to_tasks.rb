class AddDataseturlToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :dataset_url, :string
  end
end
