# pass along methods to the stream

module Gnip
  module Powertrack
    module Processor
      module StreamDelegate
        def method_missing(m, *args, &block)
          if @stream.respond_to?(m)
            @stream.send(m, *args, &block)
          else
            super(m, *args, &block)
          end
        end
      end
    end
  end
end
