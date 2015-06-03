require 'logger'
require 'forwardable'
require 'fileutils'

module Gnip

  # Simply wraps logger and makes it friendlier to use by providing log path declaration and level setting via integers
  # or symbol/string
  #
  class Logger
    extend Forwardable

    LOG_LEVELS = {
        [:unknown, 0] => Object::Logger::UNKNOWN,
        [:fatal,   1] => Object::Logger::FATAL,
        [:error,   2] => Object::Logger::ERROR,
        [:warn,    3] => Object::Logger::WARN,
        [:info,    4] => Object::Logger::INFO,
        [:debug,   5] => Object::Logger::DEBUG
    }
    DEVELOPMENT = 'development'

    # Forward on specified log methods to logger instance
    def_delegators :@logger_instance, :debug, :info, :warn, :error, :fatal, :unknown

    def initialize
      @logger_instance = logger_instance
    end

    private

    def logger_instance
      create_log_file(log_file_path)
      instance = Object::Logger.new(log_file_path)
      log_level = get_log_level
      instance.level = log_level
      instance
    end

    def log_levels
      LOG_LEVELS
    end

    def get_log_level
      #env_log_level = ThinConnector::Environment.instance.log_level
      env_log_level = 1

      if [String, Symbol].include? env_log_level.class
        log_levels.detect{ |level_arr, level| level_arr.first == env_log_level.to_sym }.to_a.flatten.last
      elsif env_log_level.is_a? Numeric
        log_levels.detect{ |level_arr, level| level_arr.last == env_log_level }.to_a.flatten.last
      else
        raise "Invalid log level #{env_log_level}"
      end
    end


    def log_file_path
      File.join './', 'log', "gnip_connector.log"
    end

    def create_log_file(file)
      return if File.exists? file
      create_log_dir file
      File.open(file, 'w'){ |f| f << "\n" + Time.now.utc.to_s }
    end

    def create_log_dir(file)
      FileUtils.mkdir_p File.dirname(file)
    end

  end
end
