# frozen_string_literal: true

require 'spec_helper'
require 'parser'

RSpec.describe Parser do
  describe '.parse' do
    let(:path_list) { double('a path list') }

    it 'adds a simple path and IP to a list' do
      file = ["/home 143.251.141.12\n"]
      expect(path_list)
        .to receive(:add_visit)
        .with(path: '/home', visit_ip: '143.251.141.12')
      Parser.parse(file: file, path_list: path_list)
    end

    it 'adds multiple paths and IPs to a list' do
      file = [
        "/home 143.251.141.12\n",
        "/index 183.151.12.151\n",
        "/help_page/1 14.234.9.225\n"
      ]
      expect(path_list)
        .to receive(:add_visit)
        .with(path: '/home', visit_ip: '143.251.141.12')
      expect(path_list)
        .to receive(:add_visit)
        .with(path: '/index', visit_ip: '183.151.12.151')
      expect(path_list)
        .to receive(:add_visit)
        .with(path: '/help_page/1', visit_ip: '14.234.9.225')
      Parser.parse(file: file, path_list: path_list)
    end

    it 'does not add a visit if the input is missing the IP address part' do
      file = ["  /home  \n"]
      expect(path_list)
        .to_not receive(:add_visit)
      Parser.parse(file: file, path_list: path_list)
    end

    it 'does not add a visit if the IPv4 address is invalid' do
      file = ["/home 715.156.286.412\n"]
      expect(path_list)
        .to_not receive(:add_visit)
      Parser.parse(file: file, path_list: path_list)
    end

    it 'does not add a visit if the path includes a colon' do
      file = ["http://example.com/home 143.251.141.12\n"]
      expect(path_list)
        .to_not receive(:add_visit)
      Parser.parse(file: file, path_list: path_list)
    end
  end
end
