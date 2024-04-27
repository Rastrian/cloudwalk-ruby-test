require 'json'
require_relative 'log_reader'
require_relative 'match_processor'

module QuakeLogParser
  class ReportGenerator
    def self.generate_report(file_path)
      log_lines = QuakeLogParser::LogReader.safe_read_log(file_path)
      match_indexes = QuakeLogParser::MatchProcessor.get_match_indexes(log_lines)
      match_list = QuakeLogParser::MatchProcessor.get_match_list(log_lines, match_indexes)
      matches_info = match_list.map { |match| QuakeLogParser::MatchProcessor.process_match(match) }

      JSON.pretty_generate({
        matches: matches_info,
        total_matches: matches_info.size
      })
    end
  end
end