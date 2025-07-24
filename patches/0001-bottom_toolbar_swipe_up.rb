#!/usr/bin/env ruby

# 0001: Change bottom toolbar swipe up for open tab list.
# Note: Original brave browser should swipe 'down' to open the tab list, even for the bottom toolbar.

# How to Track:
# - smali_classes2/org/chromium/chrome/browser/toolbar/bottom/
# - BraveScrollingBottomViewResourceFrameLayout.smali
# -> This contains MotionEvent, which invoke some class
#   - In this case, LSk3;->p:Landroid/view/GestureDetector
# - In LSk3, there is onScroll method, and it contains 0x3 to indicate 'down' swipe.
#   - Change it to 0x4 to indicate 'up' swipe.

src_smali = "smali_classes2/org/chromium/chrome/browser/toolbar/bottom/BraveScrollingBottomViewResourceFrameLayout.smali"

src = File.read(src_smali)

# Find:
# invoke-virtual {v0, p1}, L(<class>);->a(Landroid/view/MotionEvent;)Z

re = /invoke-virtual {v0, p1}, L([^;]+);->a\(Landroid\/view\/MotionEvent;\)Z/
matched = src.match(re)

if matched.nil?
  puts "[ERROR] Could not find the method in #{src_smali}"
  exit 1
end

puts "[INFO] Found class: #{matched[1]}"

class_name = matched[1]

target_file = "smali_classes2/#{class_name}.smali"

# Read file as binary
$contents = File.read(target_file)

_method_start_phrase = ".method public final onScroll(Landroid/view/MotionEvent;Landroid/view/MotionEvent;FF)Z"

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
c = $contents.gsub!(original, replacement)
if c.nil?
  puts "[ERROR] Could not find the original line in #{target_file}"
  exit 1
else
  puts "[INFO] Replaced the line in #{target_file}"
end

# Write the modified contents back to the file
File.write(target_file, $contents)
