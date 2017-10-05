require "option_parser"

require "./lib"
require "./cycle"

state : Int32|Nil = 1
transition_period : Int32|Nil = 0
hue : Int32|Nil = nil
saturation : Int32|Nil = nil
brightness : Int32|Nil = nil
color : String = ""

OptionParser.parse! do |parser|
	parser.banner = "Usage: crybulb [arguments]"
	parser.on("--off", "Turn Off") { state=0 }
	parser.on("--on", "Turn On") { state=1 }
	parser.on("-c C", "--color=C") { |c|
    hsb = Crybulb.getHSB(Crybulb.getHex(c))
    hue = hsb["h"]
    saturation = hsb["s"]
    brightness = hsb["b"]
	}
	parser.on("-b B", "--brightness=B", "Set Brightness") { |b| brightness = b.to_i  }
	parser.on("-h H", "--hue=H", "Set Hue") { |h| hue = h.to_i  }
	parser.on("-s S", "--saturation=S", "Set Saturation") { |s| saturation = s.to_i  }
	parser.on("-t T", "--transition", "Set Transition Period") { |t| transition_period = t.to_i*1000}
	parser.on("--cycle", "Enter Disco Mode") { Cycle.cycle() }
	parser.on("--help", "Show this help") { puts parser; exit }
end

# message = %({"smartlife.iot.smartbulb.lightingservice":{"transition_light_state":{"ignore_default":1,"on_off":0,"transition_period":2}}})
# message = %({"system": {"get_sysinfo": {}}})

# puts "Hue: #{hue}"
# puts "Saturation: #{saturation}"
# puts "Brightness: #{brightness}"

message = Crybulb.buildJson(hue, saturation, brightness, state, transition_period)
# puts message

Crybulb.send(message)