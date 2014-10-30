class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.float :min_latitude
      t.float :max_latitude
      t.float :min_longitude
      t.float :max_longitude
      t.float :min_gain
      t.float :max_gain
      t.float :min_height
      t.float :max_height
      t.integer :quanity

      t.timestamps
    end
  end
end
