class Dataset
	include ActiveModel::Model
	attr_accessor :min_latitude, :max_latitude, :min_longitude, :max_longitude, :min_gain, :max_gain, :min_height, :max_height, :quantity
end
