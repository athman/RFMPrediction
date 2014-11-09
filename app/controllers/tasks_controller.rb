require 'open-uri'
require 'meter_agent'

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
            #@dataset = Nokogiri::XML(open(@task.dataset.url))
            #@dataset = Nokogiri::XML(open('https://rfmprediction-assets.s3.amazonaws.com/2014/11/06/11/23/57/145/datasets_3.xml'))
            @dataset = Nokogiri::XML(open('http://rfmprediction.herokuapp.com/media/W1siZiIsIjIwMTQvMTEvMDcvMTQvMjcvMzYvMjc4L2RhdGFzZXRzXzQueG1sIl1d?sha=a92a51bf272ec3e5'))
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

=begin
For each meter
    for all other meters
        if the meter is not itself and the meter is within 5 km radius
        calculate the power received
        calculate signal loss
        calculate antenna type
        add result to result set
=end
        @results_set = Array.new

        @transmitting_meter = nil
        @distances = Array.new
        @meters.each do |meter|
            receiving_agent = MeterAgent.new meter['latitude'], meter['longitude'], meter['gain'], meter['height'], @meters
            meter_result = Hash.new
            theoretical_power_received_set = Array.new

            meter_result['latitude'] = meter['latitude']
            meter_result['longitude'] = meter['longitude']
            meter_result['height'] = meter['height']
            meter_result['gain'] = meter['gain']
            meter_result['agents_in_vicinity'] = Array.new

            receiving_agent.agents.each do |transmitting_meter|
                if receiving_agent.in_vicinity?(transmitting_meter) && !receiving_agent.is_self?(transmitting_meter)
                    agent_in_vicinity = Hash.new
                    agent_in_vicinity['agent'] = transmitting_meter
                    distance = receiving_agent.distance_between_myself_and_agent transmitting_meter
                    agent_in_vicinity['distance'] = distance
                    #@distances.push distance
                    friis_power_received = receiving_agent.friis_power_received transmitting_meter
                    agent_in_vicinity['friis_power_received'] = friis_power_received
                    signal_lost = receiving_agent.signal_lost transmitting_meter
                    agent_in_vicinity['signal_lost'] = signal_lost
                    theoretical_power_received = receiving_agent.theoretical_power_received friis_power_received, signal_lost
                    agent_in_vicinity['theoretical_power'] = theoretical_power_received
                    #theoretical_power_received_set.push theoretical_power_received
                    meter_result['agents_in_vicinity'].push agent_in_vicinity
                end
            end

            meter_result['resultant_theoretical_power_received'] = receiving_agent.resultant_theoretical_power_received theoretical_power_received_set

            if meter_result['agents_in_vicinity'].any?
                meter_result['can-communicate'] = true
            else
                meter_result['can-communicate'] = false
            end


            #meter_result['antenna_type'] = receiving_agent.antenna_type
            @results_set.push meter_result

        end


        #render xml: @meters
        #render xml: @meters

        #@inspect = @results_set
        #render xml: @results_set

        @markers = Array.new

#        @results_set.each do |result|
#            marker = Hash.new
#            marker['lat'] = result['latitude']
#            marker['lng'] = result['longitude']
#            marker['title'] = "A meter"
#            marker['picture'] = {
#				url: "https://s3.amazonaws.com/rfmprediction-assets/2014/11/07/14/27/36/278/antenna_36x36.png",
#				#url: "http://simpleicon.com/wp-content/uploads/antenna-3.png",
#				#url: "https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png",
#				#url: "/app/assets/images/antenna.png",
#				width:  36,
#				height: 36
#			  }
#            marker['infowindow'] = "A meter description"
#            @markers.push marker
#        end

        @markers = Gmaps4rails.build_markers(@results_set) do |meter, marker|
            marker.lat meter['latitude']
            marker.lng meter['longitude']
            marker.title meter['height']
            marker.infowindow meter['gain']
            marker.picture({
                    :url => "https://s3.amazonaws.com/rfmprediction-assets/2014/11/07/14/27/36/278/antenna_36x36.png",
                    #:picture => "http://www.blankdots.com/img/github-32x32.png",
                    #:picture => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=A|FF0000|000000",
                    :width => 36,
                    :height => 36
                })


            #if meter['can-communicate'] = true
            #    marker.picture({
            #        :picture => "https://s3.amazonaws.com/rfmprediction-assets/2014/11/07/14/27/36/278/antenna.png",
            #        #:picture => "http://www.blankdots.com/img/github-32x32.png",
            #        #:picture => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=A|FF0000|000000",
            #        :width => 32,
            #        :height => 32
            #    })
            #end
        end

        render "map"
        #render json: @markers
    end

    #def gmaps4rails_marker_picture
    #    {
    #        "picture" => "https://s3.amazonaws.com/rfmprediction-assets/2014/11/07/14/27/36/278/antenna.png",
    #        "width" => 20,
    #        "height" => 20,
    #        "marker_anchor" => [ 5, 10],
    #        #"shadow_picture" => "/images/morgan.png" ,
    #        "shadow_width" => "110",
    #        "shadow_height" => "110",
    #        "shadow_anchor" => [5, 10],
    #    }
    #end

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
