class AddDatasetpropertiesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :dataset_uid, :string
  end
end
