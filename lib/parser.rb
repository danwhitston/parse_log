# frozen_string_literal: true

# Courtesy of https://www.regular-expressions.info/ip.html
IPV4_MATCHER = /\A(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}
(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/x.freeze

# Courtesy of https://gist.github.com/dperini/729294
PATH_MATCHER = %r{\A(?:/[^\s]*)?\z}.freeze

# Parse a logfile and populate data to a path list
module Parser
  class << self
    def parse(file:, path_list:)
      file.each do |line|
        visit = parse_line(line)
        if valid_path?(visit[:path]) && valid_ip?(visit[:visit_ip])
          path_list.add_visit(visit)
        end
      end
    end

    private

    def parse_line(line)
      path, visit_ip = line.split(' ')
      { path: path, visit_ip: visit_ip } # has to match to PathList#add_visit
    end

    def valid_path?(path)
      PATH_MATCHER.match?(path)
    end

    def valid_ip?(ip_address)
      IPV4_MATCHER.match?(ip_address)
    end
  end
end
