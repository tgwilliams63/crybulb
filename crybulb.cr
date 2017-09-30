require "json"
require "option_parser"
require "socket"

colors = {
	"green": {"hue": 120, "saturation": 100, "brightness": 10},
	"blue": {"hue": 240, "saturation": 100, "brightness": 10},
	"red": {"hue": 360, "saturation": 100, "brightness": 10},
	"yellow": {"hue": 60, "saturation": 100, "brightness": 10},
	"teal": {"hue": 170, "saturation": 100, "brightness": 10},
	"orange": {"hue": 30, "saturation": 100, "brightness": 10},
	"pink": {"hue": 300, "saturation": 100, "brightness": 10},
	"magenta": {"hue": 300, "saturation": 100, "brightness": 10},
	"white": {"hue": 0, "saturation": 0, "brightness": 0}
}

state : Int32|Nil = 1
transition_period : Int32|Nil = 0
hue : Int32|Nil = nil
saturation : Int32|Nil = nil
brightness : Int32|Nil = nil
color : String = ""

def buildJson(hue=nil, saturation=nil, brightness=nil, state=1, transition_period=0)

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


def send(msg : String)
	sock = Socket.udp(Socket::Family::INET)
	sock.connect("192.168.1.3", 9999)

	encmsg = encrypt(msg)
	
	sock.send(encmsg)

	response = Bytes.new(1500)
	sock.read(response)
	# puts String.new(decrypt(response))
end

def encrypt(msg : String)
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

def decrypt(msg : Slice(UInt8))
	dbytes = Slice(UInt8).new(msg.bytesize)
	key = UInt8.new(171)

	msg.each_with_index do |value,index|
		ph = value
		dbytes[index] = ph ^ key
		key = ph
	end
	return dbytes
end

OptionParser.parse! do |parser|
	parser.banner = "Usage: crybulb [arguments]"
	parser.on("--off", "Turn Off") { state=0 }
	parser.on("--on", "Turn On") { state=1 }
	parser.on("-c C", "--color=C") { |c| color=c 
		if colors.has_key?(color)
			hue = colors[color]["hue"]
			saturation = colors[color]["saturation"]
			brightness = colors[color]["brightness"]
		end
	}
	parser.on("-b B", "--brightness=B", "Set Brightness") { |b| brightness = b.to_i  }
	parser.on("-h H", "--hue=H", "Set Hue") { |h| hue = h.to_i  }
	parser.on("-s S", "--saturation=S", "Set Saturation") { |s| saturation = s.to_i  }
	parser.on("-t T", "--transition", "Set Transition Period") { |t| transition_period = t.to_i*1000}
	parser.on("--help", "Show this help") { puts parser }
end

# message = %({"smartlife.iot.smartbulb.lightingservice":{"transition_light_state":{"ignore_default":1,"on_off":0,"transition_period":2}}})
# message = %({"system": {"get_sysinfo": {}}})

message = buildJson(hue, saturation, brightness, state, transition_period)
# puts message

send(message)