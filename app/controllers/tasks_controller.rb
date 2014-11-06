require 'open-uri'

class TasksController < ApplicationController
    before_action :set_task, only: [:show, :edit, :update, :destroy]

    # GET /tasks
    # GET /tasks.json
    def index
      @tasks = Task.all
    end

    # GET /tasks/1
    # GET /tasks/1.json
    def show
    end

    # GET /tasks/new
    def new
      @task = Task.new
    end

    # GET /tasks/1/edit
    def edit
    end

    # POST /tasks
    # POST /tasks.json
    def create
      @task = Task.new(task_params)

      respond_to do |format|
          if @task.save
              format.html { redirect_to @task, notice: 'Task was successfully created.' }
              format.json { render :show, status: :created, location: @task }
          else
              format.html { render :new }
              format.json { render json: @task.errors, status: :unprocessable_entity }
          end
      end
    end

    # PATCH/PUT /tasks/1
    # PATCH/PUT /tasks/1.json
    def update
      respond_to do |format|
        if @task.update(task_params)
          format.html { redirect_to @task, notice: 'Task was successfully updated.' }
          format.json { render :show, status: :ok, location: @task }
        else
          format.html { render :edit }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /tasks/1
    # DELETE /tasks/1.json
    def destroy
      @task.destroy
      respond_to do |format|
        format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def execute
        @task = Task.find(params[:id])
        if Rails.env.development?
            #File.open(@task.dataset.remote_url)
            #dataset = Nokogiri::XML(open('http://localhost:3000/media/W1siZiIsIjIwMTQvMTEvMDYvN3RqdWNteTVkc19kYXRhc2V0c18zLnhtbCJdXQ?sha=5033c6b0522d7542'))
            open('http://localhost:3000/system/dragonfly/development/2014/11/06/7tjucmy5ds_datasets_3.xml')
            #@dataset = Nokogiri::XML('http://localhost:3000/system/dragonfly/development/2014/11/06/7tjucmy5ds_datasets_3.xml')
            #@dataset = Nokogiri::XML(open(@task.dataset.remote_url))
            #@dataset = Nokogiri::XML(open('https://rfmprediction-assets.s3.amazonaws.com/2014/11/06/11/23/57/145/datasets_3.xml'))
            #@dataset = Nokogiri::XML(open(@task.dataset.url))
            #@dataset = Nokogiri::XML(open('http://localhost:3000/system/dragonfly/development/2014/11/06/7tjucmy5ds_datasets_3.xml'))
        else
            if Rails.env.production?
                @dataset = Nokogiri::XML(open(@task.dataset.remote_url))
            end
        end

        @meters = Array.new

        @dataset.css("object").each do |object|
            meter = Hash.new
            meter['latitude'] = object.at_css("latitude").text.to_s
            meter['longitude'] = object.at_css("longitude").text.to_s
            meter['gain'] = object.at_css("gain").text.to_s
            meter['height'] = object.at_css("height").text.to_s
            @meters.push(meter)
        end


        #@objects = @dataset.xpath("//object")

        #respond_to do |format|
        #    format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
        #    format.json { head :no_content }
        #end
        render xml: @meters
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_task
        @task = Task.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def task_params
        params.require(:task).permit(:user_id, :name, :description, :dataset)
      end
end
