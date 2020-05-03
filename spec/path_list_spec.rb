# frozen_string_literal: true

require 'spec_helper'
require 'path_list'

RSpec.describe PathList do
  describe '.new' do
    it 'creates successfully' do
      expect { subject }.to_not raise_error
    end
  end

  # No reason to make the list directly visible, so can't test its content
  describe '.add_visit' do
    let(:path_double) { double('path') }
    let(:ip_double) { double('an ip address') }

    it 'accepts arguments :path and :visit_ip' do
      expect do
        subject
          .add_visit(path: path_double, visit_ip: ip_double)
      end
        .to_not raise_error
    end
  end

  describe '.visit_summary' do
    it 'returns a single visit correctly' do
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      expect(subject.visit_summary)
        .to eq [{ path: '/about', visits: 1 }]
    end

    it 'returns two visits to the same path' do
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      expect(subject.visit_summary)
        .to eq [{ path: '/about', visits: 2 }]
    end

    # matcher does not check order of response as not relevant here
    it 'returns two visits to different paths' do
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      subject.add_visit(path: '/index', visit_ip: '382.335.626.855')
      expect(subject.visit_summary)
        .to contain_exactly(
          { path: '/about', visits: 1 },
          { path: '/index', visits: 1 }
        )
    end

    it 'summarises three visits, most visited first' do
      subject.add_visit(path: '/index', visit_ip: '382.335.626.855')
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      expect(subject.visit_summary)
        .to eq [
          { path: '/about', visits: 2 },
          { path: '/index', visits: 1 }
        ]
    end
  end

  describe '.unique_summary' do
    it 'returns two visits to the same path as 1 visit' do
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      expect(subject.unique_summary)
        .to eq [{ path: '/about', visits: 1 }]
    end

    it 'summarises four visits with one duplicate IP, most uniques first' do
      subject.add_visit(path: '/index', visit_ip: '382.335.626.855')
      subject.add_visit(path: '/index', visit_ip: '25.132.156.854')
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      subject.add_visit(path: '/about', visit_ip: '382.335.626.855')
      expect(subject.unique_summary)
        .to eq [
          { path: '/index', visits: 2 },
          { path: '/about', visits: 1 }
        ]
    end
  end
end
