# frozen_string_literal: true

require 'spec_helper'

# Test via the command line to mirror actual usage
RSpec.describe 'Command-line script' do
  it 'returns an error when executed with no arguments' do
    expect { system %(ruby parser.rb) }
      .to output(a_string_including('You need to specify a file'))
      .to_stderr_from_any_process
  end

  it 'returns an error when file does not exist' do
    expect { system %(ruby parser.rb spec/fixtures/non_existent_file) }
      .to output(a_string_including('No such file'))
      .to_stderr_from_any_process
  end

  # This is fragile - output has to match exactly including line-ends
  it 'accepts a small test file as input, and produces correct output' do
    expected_output = File.read('spec/fixtures/small_summary.txt')
    expect { system %(ruby parser.rb spec/fixtures/small.log) }
      .to output(expected_output)
      .to_stdout_from_any_process
  end
end
