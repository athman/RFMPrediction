class AddDatasetToTasks < ActiveRecord::Migration
  def change

  def self.up
    add_attachment :tasks, :dataset
  end

  def self.down
    remove_attachment :tasks, :dataset
  end

  end
end
