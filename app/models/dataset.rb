class Dataset
	include ActiveModel::Model
	include ActiveModel::Validations

	attr_accessor :min_latitude, :max_latitude, :min_longitude, :max_longitude, :min_gain, :max_gain, :min_height, :max_height, :quantity
	validates :min_latitude, presence: true, numericality: true
	validates :max_latitude, presence: true, numericality: true
	validates :min_longitude, presence: true, numericality: true
	validates :max_longitude, presence: true, numericality: true
	validates :min_gain, presence: true, numericality: true
	validates :max_gain, presence: true, numericality: true
	validates :min_height, presence: true, numericality: true
	validates :max_height, presence: true, numericality: true
	validates :quantity, presence:true, numericality:true
end
