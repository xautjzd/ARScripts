###################################################
# This file is about database connection
# and ORM
##################################################

require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
	adapter: 'mysql2',
	encoding: 'utf8',
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
	self.table_name = "acc"
end

class Attribute < ActiveRecord::Base
	self.table_name = "attributes"

	def euclidean_distance(another)
	 	Math.sqrt(
			(self.X_Average - another.X_Average)**2 +
			(self.Y_Average - another.Y_Average)**2 +
			(self.Z_Average - another.Z_Average)**2 +
			(self.X_Deviation - another.X_Deviation)**2 +
			(self.Y_Deviation - another.Y_Deviation)**2 +
			(self.Z_Deviation - another.Z_Deviation)**2 +
			(self.XY_Correlation - another.XY_Correlation)**2 +
			(self.YZ_Correlation - another.YZ_Correlation)**2 +
			(self.XZ_Correlation - another.XZ_Correlation)**2
		)
	end
end
