#!/usr/bin/env ruby

####################################################
# Author: xautjzd
# Date: 2014/7/2
#
# 1. Install 'rb-libsvm' gem:
# 	gem install rb-libsvm
#
# 2. Refer 'rb-libsvm' to complete SVM recognition
#
# more concorete usage, please refer:
# 	https://github.com/febeling/rb-libsvm
####################################################

require 'libsvm'
require_relative 'orm'

training_data = Attribute.take 432
testing_data = Attribute.last 100

training_set = []
action = 0 # 1:上楼 2:下楼 3:步行 4:静坐 

puts "------------------ SVM Algorithm -----------------------"
puts "Begin training..."

training_data.each do |item|
	case item.Action
	when "上楼"
		action = 1
	when "下楼"
		action = 2
	when "步行"
		action = 3
	when "静坐"
		action = 4
	else
		puts "#{item.Action} is not in the specified range!"
		exit
	end

	# Convert the feature values to specified format(Array)
	features_array = [
		item.X_Average,
		item.Y_Average,
		item.Z_Average,
		item.X_Deviation,
		item.Y_Deviation,
		item.Z_Deviation,
		item.XY_Correlation,
		item.YZ_Correlation,
		item.XZ_Correlation
	]

	training_set << [action, Libsvm::Node.features(features_array)]
end

problem = Libsvm::Problem.new
parameter = Libsvm::SvmParameter.new

parameter.cache_size = 100 # in magabytes

parameter.eps = 0.001
parameter.c = 10

problem.set_examples(
	training_set.map(&:first),
	training_set.map(&:last)
)

model = Libsvm::Model.train(problem, parameter)

puts "Completed training!"
puts "-------------------------"
puts "Begin predicting..."

# Predicting
counter = 0 # count the items of predicting correct

testing_data.each do |item|
	case item.Action
	when "上楼"
		action = 1
	when "下楼"
		action = 2
	when "步行"
		action = 3
	when "静坐"
		action = 4
	else
		puts "#{item.Action} is not in the specified range!"
		exit
	end

	# Convert the feature values to specified format(Array)
	features_array = [
		item.X_Average,
		item.Y_Average,
		item.Z_Average,
		item.X_Deviation,
		item.Y_Deviation,
		item.Z_Deviation,
		item.XY_Correlation,
		item.YZ_Correlation,
		item.XZ_Correlation
	]
	
	pred = model.predict(Libsvm::Node.features(features_array))
	if pred == action
		counter += 1
	end
end

puts "Completed predicting!"
print "SVM algorithm recognition accuracy: ", counter * 100 / testing_data.count, "%\n"
puts "--------------------------------------------------------"
