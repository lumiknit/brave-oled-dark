#!/usr/bin/env ruby

target_file = "resources.arsc"

# Background color is #131314
# 19, 19, 20 = #131314 = 0xff141313

# Read file as binary
$contents = File.binread(target_file)

def replace_color(from_list, to_color)
  from_list.each do |color|
    color_from = color.pack("C*")
    $contents.gsub!(color_from, to_color)
  end
end

colors_for_black = [
  [0x14, 0x13, 0x13, 0xff], # Material dark mode background
  [0x2c, 0x2a, 0x28, 0xff], # Omnibox clicked (search) background
]
replace_color(colors_for_black, [0x00, 0x00, 0x00, 0xff].pack("C*"))

colors_for_almost_black = [
  [0x20, 0x1f, 0x1e, 0xff], # Menu background
  [0x4b, 0x45, 0x43, 0xff], # Menu bottom
]
replace_color(colors_for_almost_black, [0x11, 0x10, 0x10, 0xff].pack("C*"))

colors_for_omnibox = [
  [57, 56, 56, 0xff], # Omnibox background
  [55, 53, 51, 0xff], # Omnibox background
]
replace_color(colors_for_omnibox, [0x22, 0x20, 0x20, 0xff].pack("C*"))

# Write the modified contents back to the file
File.binwrite(target_file, $contents)
