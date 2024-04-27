module QuakeLogParser
  class LogReader
    def self.safe_read_log(file_path)
      lines = File.readlines(file_path)
      raise RuntimeError, "File is empty" if lines.empty?
      lines
    rescue Errno::ENOENT
      raise RuntimeError, "File not found: Ensure the file path is correct."
    rescue Exception => e
      raise RuntimeError, e.message
    end
  end
end