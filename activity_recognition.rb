#!/usr/bin/env ruby

require_relative 'knn'

samples = Attribute.take(432)
inputs = Attribute.last(100)

knn = KNN.new(samples)
counter = 0
inputs.each do |input|
	data = knn.nearest_neighbours input, 3
	i = 0
	data.each do |item|
		if item[2].Action == input.Action
			i = i + 1
		end
	end
	if i > 1
		counter += 1
	end
end
print "KNN algorithm recognition accuracy:", counter, "%\n"

