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
      .map { |list_item| { path: list_item[0], visits: yield(list_item[1]) } }
      .sort_by { |list_item| list_item[:visits] }
      .reverse
  end
end
