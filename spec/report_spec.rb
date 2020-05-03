# frozen_string_literal: true

require 'spec_helper'
require 'report'

RSpec.describe Report do
  describe '.new' do
    subject { Report.new(path_list) }
    let(:path_list) { double('path list') }

    it 'creates successfully with path_list argument' do
      expect { subject }.to_not raise_error
    end
  end

  describe '.full_report' do
    subject { Report.new(path_list) }
    let(:path_list) { double('path list') }

    it 'includes a summary with page visits' do
      visit_summary = [
        ['/about', 2],
        ['/index', 1]
      ]
      allow(path_list).to receive(:visit_summary).and_return(visit_summary)
      allow(path_list).to receive(:unique_summary).and_return([])
      expect(subject.full_report).to include("/about 2\n/index 1\n")
    end

    it 'includes a summary with unique visits' do
      unique_summary = [
        ['/about', 3],
        ['/index', 1]
      ]
      allow(path_list).to receive(:visit_summary).and_return([])
      allow(path_list).to receive(:unique_summary).and_return(unique_summary)
      expect(subject.full_report).to include("/about 3\n/index 1\n")
    end

    it 'produces a full, correctly formatted report' do
      visit_summary = [
        ['/about', 5],
        ['/help/1', 3],
        ['/index', 1]
      ]
      unique_summary = [
        ['/help/1', 3],
        ['/about', 2],
        ['/index', 1]
      ]
      summary_report = <<~TESTREPORT
        Page visits:
        /about 5
        /help/1 3
        /index 1

        Unique page visits:
        /help/1 3
        /about 2
        /index 1
      TESTREPORT
      allow(path_list).to receive(:visit_summary).and_return(visit_summary)
      allow(path_list).to receive(:unique_summary).and_return(unique_summary)
      expect(subject.full_report).to include(summary_report)
    end
  end
end
