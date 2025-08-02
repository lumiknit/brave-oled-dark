#!/usr/bin/env ruby

require_relative 'helpers'

# 0001: Change bottom toolbar swipe up for open tab list.
# Note: Original brave browser should swipe 'down' to open the tab list, even for the bottom toolbar.

# How to Track:
# - smali_classes2/org/chromium/chrome/browser/toolbar/bottom/
# - BraveScrollingBottomViewResourceFrameLayout.smali
# -> This contains MotionEvent, which invoke some class
#   - In this case, LSk3;->p:Landroid/view/GestureDetector
# - In LSk3, there is onScroll method, and it contains 0x3 to indicate 'down' swipe.
#   - Change it to 0x4 to indicate 'up' swipe.

# Find layout file
layout_path = PatchHelpers.find_smali_path(
  "org/chromium/chrome/browser/toolbar/bottom/BraveScrollingBottomViewResourceFrameLayout.smali"
)
if layout_path.nil?
  puts "[ERROR] Could not find the layout file path."
  exit 1
end

layout_contents = File.read(layout_path)

# Find:
# invoke-virtual {v0, p1}, L(<class>);->a(Landroid/view/MotionEvent;)Z

re = /invoke-virtual {v0, p1}, L([^;]+);->a\(Landroid\/view\/MotionEvent;\)Z/
matched = layout_contents.match(re)

if matched.nil?
  puts "[ERROR] Could not find the method in #{layout_path}"
  exit 1
end

class_name = matched[1]
puts "[INFO] Found class: #{class_name}"

class_path = PatchHelpers.find_smali_path(
  "#{class_name}.smali"
)
class_contents = File.read(class_path)

method_start_phrase = ".method public final onScroll(Landroid/view/MotionEvent;Landroid/view/MotionEvent;FF)Z"
method_end_phrase = ".end method"

method_start_idx = class_contents.index(method_start_phrase)
method_end_idx = class_contents.index(method_end_phrase, method_start_idx)

# After the method start, find the line with const/4 p1, 0x3
original = """
    .line 92
    :cond_4
    const/4 p1, 0x3
"""

replacement = """
    .line 92
    :cond_4
    const/4 p1, 0x4
"""

# Replace the original line with the new line
success = PatchHelpers.replace_text_pattern(
  class_contents,
  original,
  replacement,
  "swipe direction pattern in #{class_path}"
)

unless success
  exit 1
end

# Write the modified contents back to the file
File.write(class_path, class_contents)
