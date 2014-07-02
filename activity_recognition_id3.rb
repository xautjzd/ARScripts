#!/usr/bin/env ruby

################################################################
# Refer: https://github.com/igrigorik/decisiontree
# Thanks very much to Igrigorik for your decisiontree
################################################################

require_relative 'orm'
require_relative 'id3_tree'

attributes = [
	"X_Average", 
	"Y_Average",
	"Z_Average",
	"X_Deviation",
	"Y_Deviation",
	"Z_Deviation",
	"XY_Correlation",
	"YZ_Correlation",
	"XZ_Correlation"
]

samples = Attribute.take(432)
inputs = Attribute.last(100)

training = []

samples.each do |sample|
	training << [sample.X_Average, sample.Y_Average, sample.Z_Average, sample.X_Deviation, sample.Y_Deviation, sample.Z_Deviation, sample.XY_Correlation, sample.YZ_Correlation, sample.XZ_Correlation, sample.Action]
end

dec_tree = DecisionTree::ID3Tree.new(
	attributes,
	training, 
	"上楼",
	X_Average: :continuous,
	Y_Average: :continuous,
	Z_Average: :continuous,
	X_Deviation: :continuous,
	Y_Deviation: :continuous,
	Z_Deviation: :continuous,
	XY_Correlation: :continuous,
	YZ_Correlation: :continuous,
	XZ_Correlation: :continuous
)

dec_tree.train

counter = 0
inputs.each do |input|
	test = [input.X_Average, input.Y_Average, input.Z_Average, input.X_Deviation, input.Y_Deviation, input.Z_Deviation, input.XY_Correlation, input.YZ_Correlation, input.XZ_Correlation, input.Action]
	decision = dec_tree.predict(test)

	if decision == test.last
		counter += 1
		puts "#{test} match success"
	end
end

print "ID3 algorithm recognition accuracy: ", counter, "%\n"
