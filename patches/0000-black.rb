#!/usr/bin/env ruby

require_relative 'helpers'

target_file = "resources.arsc"

# Background color is #131314
# 19, 19, 20 = #131314 = 0xff141313

# Read file as binary
contents = File.binread(target_file)

colors_for_black = [
  [0x14, 0x13, 0x13, 0xff], # Material dark mode background
  [0x2c, 0x2a, 0x28, 0xff], # Omnibox clicked (search) background
]
PatchHelpers.replace_color(contents, colors_for_black, [0x00, 0x00, 0x00, 0xff].pack("C*"), "black color")

colors_for_almost_black = [
  [0x3b, 0x39, 0x37, 0xff], # Menu background
  [0x4b, 0x45, 0x42, 0xff], # Menu bottom
]
PatchHelpers.replace_color(contents, colors_for_almost_black, [0x11, 0x10, 0x10, 0xff].pack("C*"), "almost black color")

colors_for_omnibox = [
  [0x39, 0x38, 0x38, 0xff], # Omnibox background
  [0x37, 0x35, 0x33, 0xff], # Omnibox background
]
PatchHelpers.replace_color(contents, colors_for_omnibox, [0x22, 0x20, 0x20, 0xff].pack("C*"), "omnibox color")

# Write the modified contents back to the file
File.binwrite(target_file, contents)
