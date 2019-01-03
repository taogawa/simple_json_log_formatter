# frozen_string_literal: true
require "simple_json_log_formatter/version"
require "logger"
require "json"

class SimpleJsonLogFormatter

  attr_accessor :opts

  # @param [Hash] opts
  # @option opts [String] time_key (default: time)
  # @option opts [String] severity_key (default: severity)
  # @option opts [String] message_key (default: message)
  # @option opts [String] datetime_format (default: nil)
  def initialize(opts={})
    @opts = opts.map {|k, v| [k.to_sym, v] }.to_h
    @opts[:time_key] = :time unless @opts.has_key?(:time_key)
    @opts[:severity_key] = :severity unless @opts.has_key?(:severity_key)
    @opts[:progname_key] = :progname unless @opts.has_key?(:progname_key)
    @opts[:message_key] ||= :message
    @opts[:datetime_format] = @opts.dig(:datetime_format)
  end

  def call(severity, time, progname, msg)
    log = [*format_time(time), *format_severity(severity), *format_progname(progname), *format_message(msg)].to_h
    "#{log.to_json}\n"
  end

  private
    def format_time(time)
      { @opts[:time_key] => time.strftime(@opts.dig(:datetime_format) || "%FT%T%:z") } if @opts[:time_key]
    end

    def format_severity(severity)
      { @opts[:severity_key] => severity } if @opts[:severity_key]
    end

    def format_progname(progname)
      { @opts[:progname_key] => progname } if @opts[:progname_key]
    end

    def format_message(msg)
      if msg.is_a?(String) && msg.start_with?("{") && msg.end_with?("}")
        msg = (JSON.parse(msg) rescue nil) || msg
      end
      { @opts[:message_key] => msg }
    end
end
