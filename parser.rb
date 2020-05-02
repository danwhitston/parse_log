#!/usr/bin/env ruby
# frozen_string_literal: true

class Parser
  def initialize
    puts '..parsing..' # This is for a base spec. Will need to modify as code updates
  end
end

# Run if invoked from command line
# Simplecov won't spot that this is covered by command-line specs
if __FILE__ == $0
  Parser.new
end