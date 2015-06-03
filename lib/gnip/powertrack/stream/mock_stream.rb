require 'json'
require 'securerandom'
require_relative '../stream/stream_base'

module Gnip
  module Powertrack
    module Stream

      class MockStream < Gnip::Powertrack::Stream::Base

        SECONDS_REST_BETWEEN_PAYLOADS = 1
        DEFAULT_MAX_TIMEOUT_IN_SECONDS = 60*5

        def initialize; @logger = ThinConnector::Logger.new end

        # Passes json strings to &block
        def start(&block)
          begin
            puts "starting loop"
            while stream_is_open?
              yield json_data.to_json
              @logger.debug json_data.to_json
              sleep_t = SECONDS_REST_BETWEEN_PAYLOADS if SECONDS_REST_BETWEEN_PAYLOADS
              puts "Sleeping #{sleep_t/10000.0}"
              sleep sleep_t/10000.0
            end

          rescue => e
            puts "Error was #{e}"
            @logger.info "Rescuing from error #{e}:#{e.message}" if logging?
            retry_count ||= 0
            retry_count += 1

            if should_try_reconnect? retry_count
              sleep seconds_between_reconnect(retry_count)
              @logger.info "Retrying to connect stream for #{retry_count} time" if logging?
              retry
            else
              @logger.error "Not retrying to connect stream, probably timed out" if logging?
            end
          end
        end

        def stop
          @stop_stream = true
        end

        private

        def stream_running?

        end

        def reconnect

        end

        def random_string; SecureRandom.hex 32; end

        def json_data
          {
              timestamp: Time.now.utc.to_f,
              payload: random_string
          }
        end

        # Unassigned @stop_stream assumed to mean stream should be open
        def stream_is_open?
          @stop_stream.nil? || !@stop_stream
        end

        def seconds_between_reconnect(attempt_number)
          (attempt_number**2) * 10
        end

        def max_timeout
          ThinConnector::Environment.instance.stream_timeout rescue DEFAULT_MAX_TIMEOUT_IN_SECONDS
        end

        def should_try_reconnect?(attempt_number)
          raise 'Cannot retry negative times' if attempt_number < 0
          seconds_between_reconnect(attempt_number) < max_timeout
        end

        def logging?
          false
        end

      end

    end
  end
end
