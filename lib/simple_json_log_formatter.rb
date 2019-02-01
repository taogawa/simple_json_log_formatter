# frozen_string_literal: true
require "simple_json_log_formatter/version"
require "json"

class SimpleJsonLogFormatter

  attr_accessor :opts

  # @param [Hash] opts
  # @option opts [String] time_key (default: time)
  # @option opts [String] severity_key (default: severity)
  # @option opts [String] progname_key (default: progname)
  # @option opts [String] message_key (default: message)
  # @option opts [String] datetime_format (default: nil)
  def initialize(opts={})
    @opts = opts.map {|k, v| [k.to_sym, v] }.to_h
    @opts[:time_key] = :time unless @opts.has_key?(:time_key)
    @opts[:severity_key] = :severity unless @opts.has_key?(:severity_key)
    @opts[:progname_key] = :progname unless @opts.has_key?(:progname_key)
    @opts[:message_key] ||= :message
    @opts[:datetime_format] = "%FT%T%:z" unless @opts.has_key?(:datetime_format)
  end

  def call(severity, time, progname, msg)
    log = {}
    log.merge!(format_time(time)) if @opts[:time_key]
    log.merge!(format_severity(severity)) if @opts[:severity_key]
    log.merge!(format_progname(progname)) if @opts[:progname_key]
    log.merge!(format_message(msg))
    "#{log.to_json}\n"
  end

  private
    def format_time(time)
      { @opts[:time_key] => time.strftime(@opts[:datetime_format]) }
    end

    def format_severity(severity)
      { @opts[:severity_key] => severity }
    end

    def format_progname(progname)
      { @opts[:progname_key] => progname }
    end

    def format_message(msg)
      if msg.is_a?(String) && msg.start_with?("{") && msg.end_with?("}")
        msg = (JSON.parse(msg) rescue nil) || msg
      end
      { @opts[:message_key] => msg }
    end
end
