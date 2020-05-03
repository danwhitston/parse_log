# frozen_string_literal: true

# Store and report on the list of paths visited
class PathList
  def initialize
    @list = Hash.new { |hash, key| hash[key] = [] }
  end

  def add_visit(parsed_visit) # parsed_visit has keys :path and :visit_ip
    @list[parsed_visit[:path]] << parsed_visit[:visit_ip]
  end

  def visit_summary
    summary_list = @list.map do |list_item|
      { path: list_item[0], visits: list_item[1].count }
    end
    summary_list.sort_by { |list_item| list_item[:visits] }.reverse
  end

  def unique_summary
    summary_list = @list.map do |list_item|
      { path: list_item[0], visits: list_item[1].uniq.count }
    end
    summary_list.sort_by { |list_item| list_item[:visits] }.reverse
  end
end
