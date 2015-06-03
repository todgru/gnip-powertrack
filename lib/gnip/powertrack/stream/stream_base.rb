module Gnip
  module Powertrack
    module Stream

      class Base

        def start(&block)
          raise 'this method should be overriden and return the data'
        end

        def stop
          raise 'this method should be overridden and close the stream safely'
        end

        protected

        def stream_running?
          raise 'this method should be overridden and return true/false depending on whether the stream is running'
        end

        def reconnect
          raise 'this method should be overridden and re-open the stream. Should also have timeout logic'
        end

        private

        # Protect constructor, only initialize with start()
        def initialize

        end

      end

    end
  end
end
