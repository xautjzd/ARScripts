#!/usr/bin/env ruby

require_relative 'orm'

class AttributeExtraction
	def initialize
		@names = []
		# Get all people participating in data sampling
		results = Acceleration.select(:Person).distinct
		results.each do |item|
			@names << item["Person"]
		end

		@actions = []
		# Get all actions of activity recognition
		results = Acceleration.select(:Action).distinct
		results.each do |item|
			@actions << item["Action"]
		end
	end

	def data_preprocessing
		puts "--------------------------------------------------------------"
		puts " Data preprocessing: begin export sample data to new table  "

		@names.each do |name|
			puts "	---#{name} begin exporting! ---"

			@actions.each do |action|
				# Filter first 50 records and only select next 200 records
				results = Acceleration.where(Person: name).where(Action: action).limit(200).offset(50)

				results.each do |result|
					Acc.create(
						DeviceId: result.DeviceId, 
						Action: result.Action,
						Person: result.Person,
						X:      result.X,
						Y:      result.Y,
						Z:      result.Z,
						Time:   result.Time
					)
				end
			end
			puts "	--- #{name} export success! ---"
		end
		puts " Data preprocessing success: All data has been imported successfully!"
		puts "--------------------------------------------------------------"
	end

	def attribute_extraction
		puts "--------------------------------------------------------------"
		puts "--- Begin attribute extracting! ---"
		@names.each do |name|
			@actions.each do |action|
				# Slide Window size is set to 20, 50% duplicate
				window_size = 20
				counter = 0
				while counter <190
					# 1. Average: Attribute extraction to each slide window
					results = Acc.where(Person: name).where(Action: action).limit(window_size).offset(counter)
					counter = counter + window_size/2

					x_sum = y_sum = z_sum = 0.0
					results.each do |result|
						x_sum += result.X
						y_sum += result.Y
						z_sum += result.Z
					end

					x_average = x_sum / window_size
					y_average = y_sum / window_size
					z_average = z_sum / window_size

					# 2. Deviation and Correlation
					x_deviation = y_deviation = z_deviation = 0.0
					l_xy = l_yz = l_xz = 0.0

					results.each do |result|
						x_deviation += (result.X - x_average)**2
						y_deviation += (result.Y - y_average)**2
						z_deviation += (result.Z - z_average)**2

						l_xy += (result.X - x_average) * (result.Y - y_average)
						l_yz += (result.Y - y_average) * (result.Z - z_average)
						l_xz += (result.X - x_average) * (result.Z - z_average)
					end

					x_deviation = x_deviation / window_size
					y_deviation = y_deviation / window_size
					z_deviation = z_deviation / window_size

					xy_correlation = l_xy / (Math.sqrt(x_deviation * y_deviation) * window_size)
					yz_correlation = l_yz / (Math.sqrt(y_deviation * z_deviation) * window_size)
					xz_correlation = l_xz / (Math.sqrt(x_deviation * z_deviation) * window_size)

					Attribute.create(
						Person: name,
						Action: action,
						X_Average: x_average,
						Y_Average: y_average,
						Z_Average: z_average,
						X_Deviation: x_deviation,
						Y_Deviation: y_deviation,
						Z_Deviation: z_deviation,
						XY_Correlation: xy_correlation,
						YZ_Correlation: yz_correlation,
						XZ_Correlation: xz_correlation
					)
				end
			end
		end
		puts "--- Attribute extracting successfully! ---"
		puts "--------------------------------------------------------------"
	end
end

ae = AttributeExtraction.new
ae.data_preprocessing
ae.attribute_extraction
