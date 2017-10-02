module Crybulb

	def self.buildJson(hue=nil, saturation=nil, brightness=nil, state=1, transition_period=0)

		base = JSON.build do |json|
			json.object do
				json.field "smartlife.iot.smartbulb.lightingservice" do 
					json.object do
						json.field "transition_light_state" do
							json.object do
								json.field "ignore_default", 1
								json.field "on_off", state
								json.field "transition_period", transition_period
								if hue
									json.field "hue", hue
								end
								if saturation
									json.field "saturation", saturation
								end
								if brightness
									json.field "brightness", brightness
								end
							end
						end
					end
				end
			end
		end

		return base

	end 

	def self.send(msg : String)
		sock = Socket.udp(Socket::Family::INET)
		sock.connect("192.168.1.3", 9999)

		encmsg = encrypt(msg)
		
		sock.send(encmsg)

		response = Bytes.new(1500)
		sock.read(response)
		# puts String.new(decrypt(response))
	end

	def self.encrypt(msg : String)
		data = IO::Memory.new(msg)

		mbytes = data.buffer.to_slice(data.bytesize)
		cbytes = Slice(UInt8).new(mbytes.bytesize)
		key = UInt8.new(171)

		mbytes.each_with_index do |value,index|
			ph = value
			cbytes[index] = ph ^ key
			key = cbytes[index]
		end
		return cbytes
	end

	def self.decrypt(msg : Slice(UInt8))
		dbytes = Slice(UInt8).new(msg.bytesize)
		key = UInt8.new(171)

		msg.each_with_index do |value,index|
			ph = value
			dbytes[index] = ph ^ key
			key = ph
		end
		return dbytes
	end

end