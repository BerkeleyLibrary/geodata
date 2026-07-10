require 'timeout'

module GeoDataHealthCheck
  class TimedHealthCheck < OkComputer::Check
    attr_reader :wrapped_check, :timeout

    def initialize(wrapped_check, timeout:)
      super()
      @wrapped_check = wrapped_check
      @timeout = timeout
    end

    def registrant_name=(name)
      super
      wrapped_check.registrant_name = name if wrapped_check.respond_to?(:registrant_name=)
    end

    def check
      Timeout.timeout(timeout) do
        wrapped_check.run
      end

      copy_wrapped_check_result
    rescue Timeout::Error
      fail_with_message "Health check timed out after #{timeout} seconds"
    rescue StandardError => e
      fail_with_message "Error: '#{e.message}'"
    end

    private

    def copy_wrapped_check_result
      mark_message wrapped_check.message
      mark_failure unless wrapped_check.success?
    end

    def fail_with_message(message)
      mark_failure
      mark_message message
    end
  end
end
