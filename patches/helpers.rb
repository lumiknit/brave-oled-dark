#!/usr/bin/env ruby

module PatchHelpers
  # Replace binary patterns with detailed logging
  def self.replace_binary_pattern(contents, from_pattern, to_pattern, description = "pattern")
    # Find all matches and their positions before replacing
    matches = []
    offset = 0
    while (pos = contents.index(from_pattern, offset))
      matches << pos
      offset = pos + 1
    end

    if matches.any?
      from_hex = from_pattern.unpack('C*').map{|c| sprintf('%02x', c)}.join('')
      to_hex = to_pattern.unpack('C*').map{|c| sprintf('%02x', c)}.join('')

      puts "[INFO] Replacing #{description} #{from_hex} with #{to_hex}"
      puts "       Found #{matches.length} occurrence(s) at byte offset(s): #{matches.join(', ')}"

      result = contents.gsub!(from_pattern, to_pattern)
      if result
        puts "       Successfully replaced #{matches.length} occurrence(s)"
      else
        puts "       [WARNING] gsub returned nil - no replacements made"
      end
    else
      from_hex = from_pattern.unpack('C*').map{|c| sprintf('%02x', c)}.join('')
      puts "[INFO] #{description.capitalize} #{from_hex} not found - no replacements needed"
    end
    puts

    matches.length
  end

  # Replace color patterns specifically
  def self.replace_color(contents, from_list, to_color, color_name = "color")
    total_replacements = 0

    from_list.each do |color|
      color_from = color.pack("C*")
      color_desc = "#{color_name} #{color.map{|c| sprintf('%02x', c)}.join('')}"

      replacements = replace_binary_pattern(contents, color_from, to_color, color_desc)
      total_replacements += replacements
    end

    total_replacements
  end

  # Replace text patterns with detailed logging
  def self.replace_text_pattern(contents, from_text, to_text, description = "text pattern")
    # Find position before replacing
    original_pos = contents.index(from_text)

    if original_pos
      puts "[INFO] Found #{description} at byte offset: #{original_pos}"
      puts "[INFO] Original content:"
      puts from_text.inspect
      puts "[INFO] Replacement content:"
      puts to_text.inspect

      result = contents.gsub!(from_text, to_text)
      if result.nil?
        puts "[ERROR] Could not replace #{description}"
        return false
      else
        puts "[INFO] Successfully replaced 1 occurrence of #{description}"
        return true
      end
    else
      puts "[ERROR] Could not find #{description}"
      puts "[DEBUG] Pattern to find:"
      puts from_text.inspect
      return false
    end
  end

  # Find smali class path helper
  def self.find_smali_path(rest)
    smali_class_paths = [
      "smali_classes2",
      "smali",
    ]

    for path in smali_class_paths
      full_path = "#{path}/#{rest}"
      if File.exist?(full_path)
        puts "[INFO] Found smali path: #{full_path}"
        return full_path
      else
        puts "[INFO] Could not find smali path: #{full_path}"
      end
    end

    nil
  end
end
