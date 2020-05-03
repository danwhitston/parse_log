# frozen_string_literal: true

# Parse a logfile and populate data to a path list
module Parser
  class << self
    def parse(file:, path_list:)
      file.each do |line|
        path_list.add_visit(parse_line(line))
      end
    end

    private

    # Parse each line into a path and an IP
    # Assumes valid input, and no spaces in path
    def parse_line(line)
      path, visit_ip = line.split(' ')
      { path: path, visit_ip: visit_ip } # has to match to PathList#add_visit
    end
  end
end
