#!/usr/bin/env ruby

require_relative 'naive_bayes.rb'

samples = Attribute.take(432)
inputs = Attribute.last(100)

nbayes = NaiveBayes.new

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

actions = []
Attribute.select(:Action).distinct.each do |item|
	actions << item.Action
end

nbayes.train(attributes, actions, samples)

# Predicting
counter = 0
inputs.each do |input|
	tokens = {
		X_Average: input.X_Average, 
		Y_Average: input.Y_Average,
		Z_Average: input.Z_Average,
		X_Deviation: input.X_Deviation,
		Y_Deviation: input.Y_Deviation,
		Z_Deviation: input.Z_Deviation,
		XY_Correlation: input.XY_Correlation,
		YZ_Correlation: input.YZ_Correlation,
		XZ_Correlation: input.XZ_Correlation
	}
	action, result = nbayes.classify tokens
	puts action, result
	if action == input.Action
		counter += 1
	end
end

print "Naive Bayes algorithm recognition accuracy: ", counter, "%\n"
