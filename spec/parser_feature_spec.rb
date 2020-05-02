# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Command-line script' do
  it 'runs without error when executed with no arguments' do
    expect { system %(ruby parser.rb) }.not_to output.to_stderr_from_any_process
  end

  it 'produces output when executed with no arguments' do
    # This expected output is temporary. Will need updating to pass in a future version
    expect { system %(ruby parser.rb) }.to output(a_string_including('..parsing..')).to_stdout_from_any_process
  end
end