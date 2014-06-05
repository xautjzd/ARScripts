#!/usr/bin/env ruby

require 'mysql2'

begin
	conn = Mysql2::Client.new(
		host: '202.200.119.165',
		username: 'root',
		password: 'root',
		port: 3306,
		database: 'sensor'
	)

	table_name = "acceleration"
	names = []
	actions = []

	# Get all people participating in data sampling
	results = conn.query "select distinct Person from #{table_name}"
	results.each do |item|
		names << item["Person"]
	end

	# Get all actions of activity recognition
	results = conn.query "select distinct Action from #{table_name}"
	results.each do |item|
		actions << item["Action"]
	end

	puts "### Data preprocessing: begin export data to new table ###"

	names.each do |name|
		puts "  ### #{name} begin exporting! ###"
		actions.each do |action|
			results = conn.query "select * from #{table_name} where Person=\"#{name}\" and Action=\"#{action}\""

			# Filter first 50 records and only select next 200 records
			$i = 0
			results.each do |item|
				$i = $i + 1
				next if $i<51
				next if $i>250
				conn.query "insert into acc(DeviceId, Action, Person, X, Y, Z, Time) values('" + item['DeviceId'] + "', '" + item['Action'] + "', '" + item['Person'] + "', " + item['X'].to_s + ", " + item['Y'].to_s + ", " + item['Z'].to_s + ", '" + item['Time'] + "')"	
			end
		end
		puts "  ### #{name} import success! ###"
	end

	puts "### Data preprocessing success: All data has been imported successfully! ###"


	puts "### Begin attribute extracting! ###"
	names.each do |name|
		actions.each do |action|
			results = conn.query "select * from acc where Person=\"#{name}\" and Action=\"#{action}\""
		end
	end

rescue Mysql2::Error => e
	puts e.errno
	puts e.error

ensure
	conn.close if conn
end
