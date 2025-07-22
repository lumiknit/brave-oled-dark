#!/usr/bin/env ruby

target_file = "resources.arsc"

# Background color is #131314
# 19, 19, 20 = #131314 = 0xff141313

# Read file as binary
contents = File.binread(target_file)

colors_for_black = [
  [0x14, 0x13, 0x13, 0xff], # Material dark mode background
  [0x2c, 0x2a, 0x28, 0xff], # Omnibox clicked (search) background
]
color_to = [0x00, 0x00, 0x00, 0xff].pack("C*") # Change to black

for color in colors_for_black
  color_from = color.pack("C*")
  contents.gsub!(color_from, color_to)
end

colors_for_almost_black = [
  [0x20, 0x1f, 0x1e, 0xff], # Menu background
  [69, 67, 75, 0xff], # Menu bottom
]
color_to = [0x10, 0x10, 0x10, 0xff].pack("C*") # Change to almost black

for color in colors_for_almost_black
  color_from = color.pack("C*")
  contents.gsub!(color_from, color_to)
end

# Write the modified contents back to the file
File.binwrite(target_file, contents)
