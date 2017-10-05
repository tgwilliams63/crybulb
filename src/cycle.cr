require "socket"

require "./lib"

module Cycle
	def self.cycle
		hue = 0

		loop do
			puts hue
			message = Crybulb.buildJson(hue, 100, 100, 1, 0)

			Crybulb.send(message)

			if hue==360
				hue=0
			else
				hue+=10
			end

			sleep 0.02
		end
	end
end