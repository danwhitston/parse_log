# frozen_string_literal: true

# Output template for a report on paths and visits
class Report
  def initialize(path_list)
    @path_list = path_list
  end

  def full_report
    "Page visits:\n" +
      visit_report(path_list.visit_summary) +
      "\nUnique page visits:\n" +
      visit_report(path_list.unique_summary)
  end

  private

  attr_reader :path_list

  def visit_report(summary_list)
    summary_list.reduce('') do |report, report_line|
      report + report_line.join(' ') + "\n"
    end
  end
end
