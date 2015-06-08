require 'eventmachine'
require 'em-http-request'
require 'json'
require_relative './stream_helper.rb'

module Gnip
  module Powertrack
    module Stream

      class Connector < Stream::Base
        include Gnip::Powertrack::Stream::StreamHelper

        EventMachine.threadpool_size = 3

        attr_accessor :headers, :options, :url, :string_buffer, :callback
        attr_reader :username, :password

        @@buffer_mutex = Mutex.new
        def initialize(url=nil, headers={})
          @logger = Gnip::Logger.new
          @url = url
          @headers = headers.merge({ accept: 'application/json'})
          @stream_reconnect_time = 1
          @string_buffer=''
        end

        def start
          if block_given?
            @processor = Proc.new
          else
            @processor = Proc.new{ |data| puts data }
          end
          connect_stream
        end

        def stop
          @stopped = true
        end

        def on_message(&block)
          @on_message = block
        end

        def on_connection_close(&block)
          @on_connection_close = block
        end

        def on_error(&block)
          @on_error = block
        end

        private

        def connect_stream
          EM.run do
            http = EM::HttpRequest.new(@url, keep_alive: true,  inactivity_timeout: 2**16, connection_timeout: 100000).get(head: @headers)
            http.stream { |chunk| process_chunk(chunk) }
            http.callback {
              handle_connection_close(http)
              reconnect
            }
            http.errback {
              handle_error(http)
              reconnect
            }

            EM.add_periodic_timer(3) do
              if stopped?
                EM.stop_event_loop
              end
            end
          end
        end

        def reconnect
          @logger.error 'Reconnecting'
          return if stopped?
          sleep @stream_reconnect_time
          bump_reconnect_time
          @logger.debug "Reconnect time bumped to: #{@stream_reconnect_time}"
          reset_reconnect_time if connect_stream
        end

        # Process message chunk
        #
        def process_chunk(message)
         Gnip::Powertrack.process(message)
        end

        def handle_error(http_connection)
          @logger.error('Error with http connection ' + http_connection.inspect)
          reconnect
        end

        def handle_connection_close(http_connection)
          @logger.warn "HTTP connection closed #{http_connection.inspect}"
          reconnect
        end

        def stopped?
          @stopped
        end

        def username=(username)
          @username = username
          @headers.merge!({ username: username })
        end

        def password=(pw)
          @password = pw
          @headers.merge!({ password: pw })
        end

      end
    end
  end
end
