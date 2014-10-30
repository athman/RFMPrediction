class DatasetsController < ApplicationController

	def index
	end

	def new
		@dataset = Dataset.new
	end

	def create
		@dataset = Dataset.new(dataset_params)
		if @dataset.valid?

			generated_set = Array.new

			@dataset.quantity.times do
				iterating_array = Array.new

			end

			flash[:notice] = "#{@dataset.min_latitude}"

			redirect_to @dataset
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
		params.require(:dataset).permit(:min_latitude, :max_latitude, :min_longitude, :max_longitude, :min_gain, :max_gain, :min_height, :max_height, :quantity)
	end

end
