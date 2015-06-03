# This class defines an interface that must be implemented by stream handlers

module Gnip
  module Powertrack
    module Processor

      class MethodCalledOnInterface < StandardError; end

      class StreamHandler

        attr_accessor :stream, :run_thread

        def initialize(stream)
          @stream = stream
          @run_thread = nil
          @stopped = false
        end

        def start
          @stream.start
          run_thread = Thread.new do
            while not stopped
              #p "fuck ya #{stream.pop}"
            end
          end
        end

        def stop
          stream.stop
          @stopped = true
          run_thread.join
        end

      end
    end
  end
end
