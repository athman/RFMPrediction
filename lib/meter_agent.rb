require 'geocoder'

class MeterAgent

	def initialize latitude_arg, longitude_arg, gain_arg, height_arg, transmitting_power_arg, frequency_arg, agents_arg #, loss_functions_arg = nil
		@latitude = latitude_arg.to_f
		@longitude = longitude_arg.to_f
		@my_location = [@latitude, @longitude]
		@gain = gain_arg.to_f
		@height = height_arg.to_f
		@transmitting_power = transmitting_power_arg.to_f
		#@transmitting_power = transmitting_power_arg ||= 30 #dBm
		@agents = agents_arg
		@friis_power_received = nil
		@resultant_theoretical_power_received = nil
		@antenna_profile = nil
		@frequency = frequency_arg.to_f #MHz
		#@loss_functions = loss_functions_arg
	end

	def agents
		@agents
	end

	def in_vicinity? agent
		distance = distance_between_myself_and_agent agent
		if distance > 1.5
			return false
		else
			return true
		end
	end

	def distance_between_myself_and_agent agent
		agent_location = [agent['latitude'].to_f, agent['longitude'].to_f]
		distance = Geocoder::Calculations.distance_between @my_location, agent_location #, options = {units: "km"}
	end

	def is_self? agent
		if agent['latitude'].to_f == @latitude && agent['longitude'].to_f == @longitude
			return true
		else
			return false
		end
	end

	def friis_power_received agent
		speed_of_light = 2.99792458e8
		distance = distance_between_myself_and_agent agent
		distance_in_meters = distance * 1000
		@friis_power_received = ((agent['transmitting_power'].to_f ||= 30) * @gain * agent['gain'].to_f * (speed_of_light ** 2))/(4 * Math::PI * distance_in_meters * @frequency) ** 2
	end

	def theoretical_power_received friis_power_received_arg, signal_lost_arg
		#friis_power_received_arg - signal_lost_arg
		# For some weird reason we have to add the lost signal cuz it's returned as negative
		theoretical_power_received_value = 30 + signal_lost_arg
	end

	def resultant_theoretical_power_received theoretical_power_received_set
		# =!> Not sure of the algorithm
		maximum_power_received = theoretical_power_received_set.max
	end

	def maximum_power_received theoretical_power_received_set
		if theoretical_power_received_set.count > 0
			maximum_power_received = theoretical_power_received_set.min
		else
			maximum_power_received = 0
		end
	end

	def minimum_power_received theoretical_power_received_set
		if theoretical_power_received_set.count > 0
			minimum_power_received = theoretical_power_received_set.max
		else
			minimum_power_received = 0
		end
	end

	def antenna_type
		minimum_power_required = 90 #dBm
		#code
	end

	def antenna_required maximum_power_received, minimum_power_received
		if maximum_power_received < (minimum_power_received - 10)
			antenna = "High Profile"
		elsif minimum_power_received - 10 <= maximum_power_received && maximum_power_received < minimum_power_received
			antenna = "Low Profile"
		elsif minimum_power_received <= maximum_power_received && maximum_power_received < (minimum_power_received + 10)
			"Low Profile"
		else
			"---"
		end

	end

	def signal_lost agent
		egli_loss_value = egli_loss_model agent
		#metal_meter_box_loss_value = metal_meter_box_loss
		#atmospheric_loss_value = atmospheric_loss

		#total_loss = egli_loss_value + metal_meter_box_loss_value

	end

	def egli_loss_model agent
		distance = distance_between_myself_and_agent agent
		distance_in_meters = distance * 1000
		#egli_loss = agent['gain'].to_f * @gain * (((@height * agent['height'].to_f) / distance_in_meters) ** 2) * ((40 / @frequency) ** 2)
		egli_loss = (20 * Math.log(@height * agent['height'].to_f, 10)) - (20 * Math.log(distance_in_meters ** 2, 10)) + (20 * Math.log(40, 10)) - (10 * Math.log(@frequency ** 2, 10))
	end

	def metal_meter_box_loss
		10 #dB
	end

	def atmospheric_loss

	end

end
