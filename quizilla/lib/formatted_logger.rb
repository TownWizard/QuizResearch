module FormattedLogger
  class MyFormattedLogger < Logger
    def format_message(severity, timestamp, progname, msg)
      "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n"
    end

    def log_exception( ex, severity = Logger::INFO )
      self.add severity, "=== Exception ==="
      self.add severity, ex.message
      ex.backtrace.each do |line|
        self.add severity, "    #{line}"
      end
      self.add severity, "================="
    end
  end
end