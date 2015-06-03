module Gnip
  module Powertrack
    module Stream
      module StreamHelper

        MAX_RECONNECT_SECONDS = 60 * 5

        def bump_reconnect_time
          @stream_reconnect_time = @stream_reconnect_time * 2
          raise "Max reconnection time reached" if @stream_reconnect_time > max_reconnect_time
        end

        def reset_reconnect_time
          @stream_reconnect_time = 0
        end

        def max_reconnect_time
          MAX_RECONNECT_SECONDS
        end
      end
    end
  end
end
