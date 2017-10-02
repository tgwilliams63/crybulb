# Crybulb

Crystal Program for controlling your TP-Link Lightbulb

# Build Crybulb

For most use cases this should work:

```
	crystal build ./crybulb.cr --release
```

At the time of writing there is an issue I ran into with a certain version of LLVM where the --release flag wasn't working unless you also included --no-debug. Use the below command if you get an error compiling the release version:

	```crystal build ./crybulb.cr --release --no-debug```

# Usage

```
	./crybulb [arguments]

	--off 					"Turn Off"
	--on 					"Turn On"
	-c C, --color=C 	
	-b B, --brightness=B 	"Set Brightness"
	-h H, --hue=H 			"Set Hue"
	-s S, --saturation=S 	"Set Saturation"
	-t T, --transition 		"Set Transition Period"
	--cycle					"Enter Disco Mode"
	--help 					"Show this help"
```

# Details

Right now the -c command expects lowercase colors, and the values it accepts can be found in the "colors" Named Tuple inside of the crybulb.cr file. This list should be easily expandable if you want to add your own custom colors.

# Examples

Turn light bulb on and off:

```
	./crybulb --on
	./crybulb --off
```

Set to blue or red:

```
	./crybulb -c blue
	./crybulb -c red
```