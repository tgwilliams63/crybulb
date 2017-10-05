require "json"
require "socket"

require "./colors"

CList = Colors.clist

module Crybulb

	def self.getHex(color)
		if CList.has_key?(color.downcase)
	    hex = CList[color.downcase]
	    hex = hex.to_s
	    return hex
	  else
	  	message = %({"system": {"get_sysinfo": {}}})
	  	originfo = Crybulb.send(message)
	  	joinfo = JSON.parse(originfo.strip)
	  	ohue = joinfo["system"]["get_sysinfo"]["light_state"]["hue"].as_i?
	  	osat = joinfo["system"]["get_sysinfo"]["light_state"]["saturation"].as_i?
	  	obri = joinfo["system"]["get_sysinfo"]["light_state"]["brightness"].as_i?

	  	hsb = getHSB(CList["red"])
	  	message = Crybulb.buildJson(hsb["h"], hsb["s"], hsb["b"], 1, 0)
	  	Crybulb.send(message)
	  	sleep 0.2

	  	hsb = getHSB(CList["orange"])
	  	message = Crybulb.buildJson(hsb["h"], hsb["s"], hsb["b"], 1, 0)
	  	Crybulb.send(message)
	  	sleep 0.2

	  	hsb = getHSB(CList["red"])
	  	message = Crybulb.buildJson(hsb["h"], hsb["s"], hsb["b"], 1, 0)
	  	Crybulb.send(message)
	  	sleep 0.2

	  	message = Crybulb.buildJson(ohue, osat, obri, 1, 0)
	  	Crybulb.send(message)
	  	sleep 0.2

	  	exit
	  end
	end

	def self.getHSB(hex)
	  url = "http://rgb.to/save/json/color/#{hex}"
	  HTTP::Client.get(url) do |response|
	    resjson = JSON.parse(response.body_io.gets_to_end)
	    resjson = resjson["hsb"]
	    return {"h": resjson["h"].as_i?, "s": resjson["s"].as_i?, "b": resjson["b"].as_i?}
	  end
	end

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
		sock.connect("192.168.1.2", 9999)

		encmsg = encrypt(msg)
		
		sock.send(encmsg)

		saferes = Slice(UInt8).empty
		response = Bytes.new(1500)
		sock.read(response)

		response.each_with_index do |value, key|
			# puts typeof(value)
			# puts "Value: #{value}, Index: #{key}"
			if value==0
				saferes = response[0,key]
				break
			end
		end

		# puts saferes

		return String.new(decrypt(saferes))
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