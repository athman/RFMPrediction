#class RangeValidator < ActiveModel::Validator
#	def validate dataset
#		unless dataset.min_latitude < dataset.max_latitude
#			dataset.errors.add :min_latitude, "Needs to be less than max_latitude"
#			dataset.errors.add(:min_latitude, "Can't be less than maximum latitude")
#			dataset.errors.add(:max_latitude, "Can't be less than minimum latitude")
#		end
#	end
#end

class Dataset
	include ActiveModel::Model
	include ActiveModel::Validations


	#attr_accessor :min_latitude, :max_latitude, :min_longitude, :max_longitude, :min_gain, :max_gain, :min_height, :max_height, :quantity
	attr_accessor :min_latitude, :max_latitude, :min_longitude, :max_longitude, :quantity

	validates :min_latitude, presence: true, numericality: true
	validates :max_latitude, presence: true, numericality: true
	validates :min_longitude, presence: true, numericality: true
	validates :max_longitude, presence: true, numericality: true

	#validates :min_gain, presence: true, numericality: true
	#validates :max_gain, presence: true, numericality: true
	#validates :min_height, presence: true, numericality: true
	#validates :max_height, presence: true, numericality: true
	validates :quantity, presence:true, numericality:true
	#validate :min_latitude_less_than_max_latitude, on: :create #, :min_longitude_less_than_max_longitude

	#def min_latitude_less_than_max_latitude
	#	unless min_latitude < max_latitude
	#		errors.add(:min_latitude, "Can't be less than maximum latitude")
	#		errors.add(:max_latitude, "Can't be less than minimum latitude")
	#	end
	#end

	#validates_with RangeValidator
end
