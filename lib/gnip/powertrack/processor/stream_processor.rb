# This class defines an interface that must be implemented by stream handlers


module Gnip
  module Powertrack
    module Processor

      class MethodCalledOnInterface < StandardError; end

      class StreamHandler

        attr_accessor :stream

        def initialize(stream)
          throw MethodCalledOnInterface('This method should be implemented by your own stream handler class. It should take in a Stream::GnipStream')
        end

        def start
          throw MethodCalledOnInterface('This method should be implemented by your own class. It should start the stream and pass in a block')
        end

        def stop
          throw MethodCalledOnInterface('This method should be implemented by your own class. It should call stop on the stream and perform any cleanup of resources necessary')
        end

      end
    end
  end
end
