# frozen_string_literal: true

# Store and report on the list of paths visited
class PathList
  def initialize
    @list = Hash.new { |hash, key| hash[key] = [] }
  end

  def add_visit(parsed_visit)
    # parsed_visit has keys :path and :visit_ip
    @list[parsed_visit[:path]] << parsed_visit[:visit_ip]
  end

  def visit_summary
    summary_by(&:count)
  end

  def unique_summary
    summary_by { |visits| visits.uniq.count }
  end

  private

  def summary_by
    @list
      .transform_values { |ip_list| yield(ip_list) }
      .sort_by { |path, visits| [-visits, path] }
  end
end
