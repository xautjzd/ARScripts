#!/usr/bin/env ruby

require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
	adapter: 'mysql2',
	host: '202.200.119.165',
	username: 'root',
	password: 'root',
	port: 3306,
	database: 'sensor'
)

class Acceleration < ActiveRecord::Base
	self.table_name = 'acceleration'
end

class Acc < ActiveRecord::Base
	self.table_name = 'acc'
end

class ActivityRecognition
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
		puts "### Data preprocessing: begin export data to new table ###"

		@names.each do |name|
			puts "### #{name} begin exporting! ###"

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
			puts "  ### #{name} import success! ###"
		end
		puts "### Data preprocessing success: All data has been imported successfully! ###"
	end

	def attribute_extraction
		puts "### Begin attribute extracting! ###"
	end
end

ar = ActivityRecognition.new
ar.data_preprocessing
