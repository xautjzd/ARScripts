require_relative 'orm'

class NaiveBayes
	def initialize
		@attributes = []
		@training = []
		@results = {}
	end

	# attributes: Array
	# training: Array
	def train(attributes, actions, training, type = :continuous)
		if attributes.instance_of? Array
			@attributes = attributes

			actions.each do |item|
				@results[item] = 0
			end
		else
			puts "Parameter error: the first param should be Array."
		end

		if training.instance_of? Array
			@training = training
		else
			puts "Parameter error: the second param should be Array."
		end
		@type = type
	end

	def classify(attribute = {})
		if attribute.instance_of? Hash
			case @type
			when :continuous
				nbayes_continuous attribute
			when :discrete
				nbayes_continuous attribute
			else
				puts "the third argument must be continuous or discrete, and the default value is continuous."
			end
		else
			puts "Parameter error: it must be instance of Hash."
		end
	end

	def nbayes_continuous(attribute = {})
		# P(A|B) = P(B|A) * P(A) / P(B)
		@results.keys.each do |action|
			all_count = @training.count
			a_count = @training.select { |item| item.Action == action }.count
			p_a = a_count / all_count
			p_b = @training.select { |item| item.X_Average <= attribute[:X_Average] }.count *
						@training.select { |item| item.Y_Average <= attribute[:Y_Average] }.count *
						@training.select { |item| item.Z_Average <= attribute[:Z_Average] }.count *
						@training.select { |item| item.X_Deviation <= attribute[:X_Deviation] }.count *
						@training.select { |item| item.Y_Deviation <= attribute[:Y_Deviation] }.count *
						@training.select { |item| item.Z_Deviation <= attribute[:Z_Deviation] }.count *
						@training.select { |item| item.XY_Correlation <= attribute[:XY_Correlation] }.count *
						@training.select { |item| item.YZ_Correlation <= attribute[:YZ_Correlation] }.count *
						@training.select { |item| item.XZ_Correlation <= attribute[:XZ_Correlation] }.count / (all_count**attribute.keys.count)

			p_ba = @training.select { |item| item.X_Average <= attribute[:X_Average] }.count *
						 @training.select { |item| item.Y_Average <= attribute[:Y_Average] }.count *
						 @training.select { |item| item.Z_Average <= attribute[:Z_Average] }.count *
						 @training.select { |item| item.X_Deviation <= attribute[:X_Deviation] }.count *
						 @training.select { |item| item.Y_Deviation <= attribute[:Y_Deviation] }.count *
						 @training.select { |item| item.Z_Deviation <= attribute[:Z_Deviation] }.count *
						 @training.select { |item| item.XY_Correlation <= attribute[:XY_Correlation] }.count *
						 @training.select { |item| item.YZ_Correlation <= attribute[:YZ_Correlation] }.count *
						 @training.select { |item| item.XZ_Correlation <= attribute[:XZ_Correlation] }.count / (a_count**attribute.keys.count)

			@results[action] = p_ba * p_a / p_b
		end

		max_probability @results
	end

	def nbayes_discrete(attribute = {})
	end

	# Get the most probable result
	def max_probability(result)
		# result.sort{|a, b| a[1] <=> b[1]}.last
		max_value = result.values.max
		key = result.select{|k, v| v == max_value }.keys.first
		return key, max_value
	end 
end
