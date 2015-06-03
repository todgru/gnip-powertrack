# this loads the sample code namespace in "ThinConnector"
# @todo dynamically load files
#
puts 'load req files'
require_relative './gnip/hash'
require_relative './gnip/logger'

require_relative './gnip/powertrack/process'

require_relative './gnip/powertrack/stream/stream_helper'
require_relative './gnip/powertrack/stream/mock_stream'
require_relative './gnip/powertrack/stream/stream_base'
require_relative './gnip/powertrack/stream/gnip_stream'

require_relative './gnip/powertrack/processor/stream_delegate'
require_relative './gnip/powertrack/processor/stream_processor'

puts 'gnip loaded'
