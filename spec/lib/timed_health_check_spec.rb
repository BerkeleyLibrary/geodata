require 'rails_helper'
require_relative '../../lib/geo_data_health_check'

RSpec.describe GeoDataHealthCheck::TimedHealthCheck do
  let(:passing_health_check_class) do
    Class.new(OkComputer::Check) do
      def check
        mark_message 'ok'
      end
    end
  end

  let(:failing_health_check_class) do
    Class.new(OkComputer::Check) do
      def check
        mark_failure
        mark_message 'failed'
      end
    end
  end

  let(:slow_health_check_class) do
    Class.new(OkComputer::Check) do
      def check
        sleep 0.2
        mark_message 'too late'
      end
    end
  end

  it 'preserves a passing wrapped check result' do
    check = described_class.new(passing_health_check_class.new, timeout: 0.1)

    check.run

    expect(check).to be_success
    expect(check.message).to eq('ok')
  end

  it 'preserves a failing wrapped check result' do
    check = described_class.new(failing_health_check_class.new, timeout: 0.1)

    check.run

    expect(check).not_to be_success
    expect(check.message).to eq('failed')
  end

  it 'fails when the wrapped check exceeds the timeout' do
    check = described_class.new(slow_health_check_class.new, timeout: 0.01)

    check.run

    expect(check).not_to be_success
    expect(check.message).to eq('Health check timed out after 0.01 seconds')
    expect(check.time).to be < 0.1
  end

  it 'passes the registered check name to the wrapped check' do
    wrapped_check = passing_health_check_class.new
    check = described_class.new(wrapped_check, timeout: 0.1)

    check.registrant_name = 'database'

    expect(wrapped_check.registrant_name).to eq('database')
  end
end
