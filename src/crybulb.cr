require "option_parser"

require "./lib.cr"
require "./cycle.cr"

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
	parser.on("--cycle", "Enter Disco Mode") { Cycle.cycle() }
	parser.on("--help", "Show this help") { puts parser; exit }
end

# message = %({"smartlife.iot.smartbulb.lightingservice":{"transition_light_state":{"ignore_default":1,"on_off":0,"transition_period":2}}})
# message = %({"system": {"get_sysinfo": {}}})

message = Crybulb.buildJson(hue, saturation, brightness, state, transition_period)
# puts message

Crybulb.send(message)