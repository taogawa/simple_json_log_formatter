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
    event = {}
    event[@opts[:time_key]] = time.strftime(@opts[:datetime_format]) if @opts[:time_key]
    event[@opts[:severity_key]] = severity if @opts[:severity_key]
    event[@opts[:progname_key]] = progname if @opts[:progname_key]
    event[@opts[:message_key]] = format_message(msg)
    "#{event.to_json}\n"
  end

  private
    def format_message(msg)
      if msg.is_a?(String) && msg.start_with?("{") && msg.end_with?("}")
        msg = (JSON.parse(msg) rescue nil) || msg
      end
      msg
    end
end
