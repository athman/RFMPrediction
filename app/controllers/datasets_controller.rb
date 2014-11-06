class DatasetsController < ApplicationController

	def index
	end

	def new
		@dataset = Dataset.new
	end

	def create
		@dataset = Dataset.new(dataset_params)
		if @dataset.valid?

			@generated_set = Array.new

			@dataset.quantity.to_i.times do |n|
				i = Hash.new
				i['latitude'] = Random.new.rand(@dataset.min_latitude.to_f..@dataset.max_latitude.to_f).round(6)
				i['longitude'] = Random.new.rand(@dataset.min_longitude.to_f..@dataset.max_longitude.to_f).round(6)
				#i['gain'] = Random.new.rand(@dataset.min_gain.to_f..@dataset.max_gain.to_f).round(2)
				i['gain'] = 1;
				#i['height'] = Random.new.rand(@dataset.min_height.to_f..@dataset.max_height.to_f).round(1)
				i['height'] = 1.5
				@generated_set.push(i)
			end

			render xml: @generated_set
		else
			render 'new'
		end
	end

	def show
		@dataset = dataset.find(params[:id])
	end

	def edit
	end

	def update
		@dataset = dataset.find(params[:id])
		if @dataset.update_attributes(dataset_params)
			flash[:success] = "Dataset updated successfully"
			redirect_to @dataset
		else
			render "edit"
		end

	end

	def destroy
		Dataset.find(params[:id]).destroy
		flash[:success] = "The dataset has been deleted successfully"
		redirect_to datasets_path
	end

	def dataset_params
		#params.require(:dataset).permit(:min_latitude, :max_latitude, :min_longitude, :max_longitude, :min_gain, :max_gain, :min_height, :max_height, :quantity)
		params.require(:dataset).permit(:min_latitude, :max_latitude, :min_longitude, :max_longitude, :quantity)
	end

end
