require 'quake_log_parser/report_generator'

RSpec.describe QuakeLogParser::ReportGenerator do
  describe ".generate_report" do
    it "generates a JSON report from log file path" do
      allow(QuakeLogParser::LogReader).to receive(:safe_read_log).and_return(['InitGame:', '20:34 Kill: 2 3 7: John killed Jane by MOD_ROCKET', 'ShutdownGame:'])
      allow(QuakeLogParser::MatchProcessor).to receive(:get_match_indexes).and_return([0])
      allow(QuakeLogParser::MatchProcessor).to receive(:get_match_list).and_return([['InitGame:', '20:34 Kill: 2 3 7: John killed Jane by MOD_ROCKET', 'ShutdownGame:']])
      allow(QuakeLogParser::MatchProcessor).to receive(:process_match).and_return({total_kills: 1, players: ['John', 'Jane'], deaths_by_cause: {'MOD_ROCKET' => 1}})

      expected_output = JSON.pretty_generate({matches: [{total_kills: 1, players: ['John', 'Jane'], deaths_by_cause: {'MOD_ROCKET' => 1}}], total_matches: 1})
      expect(described_class.generate_report('dummy_path')).to eq(expected_output)
    end
  end
end
