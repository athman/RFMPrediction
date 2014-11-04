# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  dataset_url :string(255)
#

class Task < ActiveRecord::Base
	dragonfly_accessor :dataset

	validates :name, presence: true
	validates :description, presence: true

	validates :dataset, presence: true

	#validates_property :format, of: :dataset, in: [:xml], case_sensitive: false, message: "should be .xml" #, if: :dataset_changed?
    validates_property :mime_type, of: :dataset, in: ['application/xml'], case_sensitive: false


	#validates_property :format, of: :dataset, in: [:xml], case_sensitive: false, message: "The data set should be an xml file", if: :dataset_changed?
end
