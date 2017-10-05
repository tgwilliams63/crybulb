require "json"
require "http/client"
require "option_parser"

module Colors
  def self.clist
    colors = {
      "lightcoral": "F08080",
      "rosybrown":  "BC8F8F",
      "indianred":  "CD5C5C",
      "red":  "FF0000",
      "firebrick":  "B22222",
      "brown":  "A52A2A",
      "darkred":  "8B0000",
      "maroon": "800000",
      "mistyrose":  "FFE4E1",
      "salmon": "FA8072",
      "tomato": "FF6347",
      "darksalmon": "E9967A",
      "coral":  "FF7F50",
      "orangered":  "FF4500",
      "lightsalmon":  "FFA07A",
      "sienna": "A0522D",
      "seashell": "FFF5EE",
      "chocolate":  "D2691E",
      "saddlebrown":  "8B4513",
      "sandybrown": "F4A460",
      "peachpuff":  "FFDAB9",
      "peru": "CD853F",
      "linen":  "FAF0E6",
      "bisque": "FFE4C4",
      "darkorange": "FF8C00",
      "burlywood":  "DEB887",
      "antiquewhite": "FAEBD7",
      "tan":  "D2B48C",
      "navajowhite":  "FFDEAD",
      "blanchedalmond": "FFEBCD",
      "papayawhip": "FFEFD5",
      "moccasin": "FFE4B5",
      "orange": "FFA500",
      "wheat":  "F5DEB3",
      "oldlace":  "FDF5E6",
      "floralwhite":  "FFFAF0",
      "darkgoldenrod":  "B8860B",
      "goldenrod":  "DAA520",
      "cornsilk": "FFF8DC",
      "gold": "FFD700",
      "lemonchiffon": "FFFACD",
      "khaki":  "F0E68C",
      "palegoldenrod":  "EEE8AA",
      "darkkhaki":  "BDB76B",
      "ivory":  "FFFFF0",
      "lightyellow":  "FFFFE0",
      "beige":  "F5F5DC",
      "lightgoldenrodyellow": "FAFAD2",
      "yellow": "FFFF00",
      "olive":  "808000",
      "olivedrab":  "6B8E23",
      "yellowgreen":  "9ACD32",
      "darkolivegreen": "556B2F",
      "greenyellow":  "ADFF2F",
      "chartreuse": "7FFF00",
      "lawngreen":  "7CFC00",
      "darkseagreen": "8FBC8B",
      "honeydew": "F0FFF0",
      "palegreen":  "98FB98",
      "lightgreen": "90EE90",
      "lime": "00FF00",
      "limegreen":  "32CD32",
      "forestgreen":  "228B22",
      "green":  "008000",
      "darkgreen":  "006400",
      "seagreen": "2E8B57",
      "mediumseagreen": "3CB371",
      "springgreen":  "00FF7F",
      "mintcream":  "F5FFFA",
      "mediumspringgreen":  "00FA9A",
      "mediumaquamarine": "66CDAA",
      "aquamarine": "7FFFD4",
      "turquoise":  "40E0D0",
      "lightseagreen":  "20B2AA",
      "mediumturquoise":  "48D1CC",
      "azure":  "F0FFFF",
      "lightcyan":  "E0FFFF",
      "paleturquoise":  "AFEEEE",
      "aqua": "00FFFF",
      "cyan": "00FFFF",
      "darkcyan": "008B8B",
      "teal": "008080",
      "darkslategray":  "2F4F4F",
      "darkturquoise":  "00CED1",
      "cadetblue":  "5F9EA0",
      "powderblue": "B0E0E6",
      "lightblue":  "ADD8E6",
      "deepskyblue":  "00BFFF",
      "skyblue":  "87CEEB",
      "lightskyblue": "87CEFA",
      "steelblue":  "4682B4",
      "aliceblue":  "F0F8FF",
      "dodgerblue": "1E90FF",
      "lightslategray": "778899",
      "slategray":  "708090",
      "lightsteelblue": "B0C4DE",
      "cornflowerblue": "6495ED",
      "royalblue":  "4169E1",
      "ghostwhite": "F8F8FF",
      "lavender": "E6E6FA",
      "blue": "0000FF",
      "mediumblue": "0000CD",
      "darkblue": "00008B",
      "midnightblue": "191970",
      "navy": "000080",
      "slateblue":  "6A5ACD",
      "darkslateblue":  "483D8B",
      "mediumslateblue":  "7B68EE",
      "mediumpurple": "9370DB",
      "blueviolet": "8A2BE2",
      "indigo": "4B0082",
      "darkorchid": "9932CC",
      "darkviolet": "9400D3",
      "mediumorchid": "BA55D3",
      "thistle":  "D8BFD8",
      "plum": "DDA0DD",
      "violet": "EE82EE",
      "fuchsia":  "FF00FF",
      "magenta":  "FF00FF",
      "darkmagenta":  "8B008B",
      "purple": "800080",
      "orchid": "DA70D6",
      "mediumvioletred":  "C71585",
      "deeppink": "FF1493",
      "hotpink":  "FF69B4",
      "lavenderblush":  "FFF0F5",
      "palevioletred":  "DB7093",
      "crimson":  "DC143C",
      "pink": "FFC0CB",
      "lightpink":  "FFB6C1",
      "white":  "FFFFFF",
      "snow": "FFFAFA",
      "whitesmoke": "F5F5F5",
      "gainsboro":  "DCDCDC",
      "lightgray":  "D3D3D3",
      "silver": "C0C0C0",
      "darkgray": "A9A9A9",
      "gray": "808080",
      "dimgray":  "696969",
      "black":  "000000"
    }
  end
end

# hex = String

# OptionParser.parse! do |parser|
#   parser.on("-c", "--color C", "Find HSB") { |c|
#     if colors.has_key?(c.downcase)
#       hex = colors[c.downcase]["hex"]
#       hex = hex.to_s.delete("#")
#       url = "http://rgb.to/save/json/color/#{hex}"
#       HTTP::Client.get(url) do |response|
#         resjson = JSON.parse(response.body_io.gets_to_end)
#         hue = resjson["h"]
#         saturation = resjson["s"]
#         brightness = resjson["b"]
#       end
#     else
#       puts "Invalid Color"
#       exit
#     end
#   }
# end

# hex = hex.to_s.delete("#")
# # puts hex

# url = "http://rgb.to/save/json/color/#{hex}"

# # puts url

# HTTP::Client.get(url) do |response|
#   # puts client.tls? # => true
#   # puts response.body_io.gets_to_end
#   resjson = JSON.parse(response.body_io.gets_to_end)
#   puts resjson["hsb"]
# end