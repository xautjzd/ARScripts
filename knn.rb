###########################################################
# Implement the KNN recognition method
# Usage:
# 	1. pass the sample data to knn class
# 	2. call nearest_neighbours to complete the recognition
# 	process.
#
# Refer: https://github.com/reddavis/knn
###########################################################

require_relative 'orm'

class KNN
	def initialize(data)
		@data = data

		@names = []
		# Get all people participating in data sampling
		results = Attribute.select(:Person).distinct
		results.each do |item|
			@names << item["Person"]
		end

		@actions = []
		# Get all actions of activity recognition
		results = Attribute.select(:Action).distinct
		results.each do |item|
			@actions << item["Action"]
		end
	end

	def nearest_neighbours(input, k=3)
		find_closest_data(input, k)
	end

	def find_closest_data(input, k)
		begin
			calculated_distances = []

			@data.each_with_index do |datum, index|
				# euclidean_distance method is defind in the Acc class
				distance = input.send :euclidean_distance, datum
				calculated_distances << [index, distance, datum]
			end

			# Sort by distance desc, and get the first k records
			calculated_distances.sort {|x, y| x[1] <=> y[1]}.first(k)
		rescue NoMethodError
			raise "There is no measurement method!"
		end
	end
end
