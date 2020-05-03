# frozen_string_literal: true

require 'spec_helper'
require 'parser'

RSpec.describe Parser do
  describe '.parse' do
    let(:path_list) { double('a path list') }

    it 'adds a simple path and IP to a list' do
      file = ["/home 382.335.626.855\n"]
      expect(path_list)
        .to receive(:add_visit)
        .with(path: '/home', visit_ip: '382.335.626.855')
      Parser.parse(file: file, path_list: path_list)
    end

    it 'adds multiple paths and IPs to a list' do
      file = [
        "/home 382.335.626.855\n",
        "/index 929.398.951.889\n",
        "/help_page/1 715.156.286.412\n"
      ]
      expect(path_list)
        .to receive(:add_visit)
        .with(path: '/home', visit_ip: '382.335.626.855')
      expect(path_list)
        .to receive(:add_visit)
        .with(path: '/index', visit_ip: '929.398.951.889')
      expect(path_list)
        .to receive(:add_visit)
        .with(path: '/help_page/1', visit_ip: '715.156.286.412')
      Parser.parse(file: file, path_list: path_list)
    end
  end
end
