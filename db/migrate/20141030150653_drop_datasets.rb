class DropDatasets < ActiveRecord::Migration
  def change
	drop_table :datasets
  end
end
