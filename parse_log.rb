#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/path_list'
require_relative 'lib/report'
require_relative 'lib/parser'

# Simplecov does not show coverage from this file
filename = ARGV.first
raise 'You need to specify a file' if filename.nil?

file = File.new(filename)
path_list = PathList.new
report = Report.new(path_list)

Parser.parse(file: file, path_list: path_list)

puts report.full_report
