require 'quake_log_parser/match_processor'

RSpec.describe QuakeLogParser::MatchProcessor do
  describe ".get_match_indexes" do
    it "returns indexes of 'InitGame:' entries" do
      log = ["InitGame:", "some action", "InitGame:", "another action"]
      expect(described_class.get_match_indexes(log)).to eq([0, 2])
    end
  end

  describe ".get_match_list" do
    it "divides the log into matches based on 'InitGame:' indexes" do
      log = ["InitGame:", "action1", "InitGame:", "action2"]
      indexes = [0, 2]
      expect(described_class.get_match_list(log, indexes)).to eq([["InitGame:", "action1"], ["InitGame:", "action2"]])
    end
  end

  describe ".parse_kill_line" do
    it "extracts killer, victim, and method from a kill line" do
      line = "20:34 Kill: 2 3 7: John killed Jane by MOD_ROCKET"
      expect(described_class.parse_kill_line(line)).to eq(['John', 'Jane', 'MOD_ROCKET'])
    end
  end

  describe ".update_scores" do
    context "when killer is not '<world>'" do
      it "increments the killer's score" do
        players = {}
        described_class.update_scores(players, 'John', 'Jane')
        expect(players).to eq({'John' => 1, 'Jane' => 0})
      end
    end

    context "when killer is '<world>'" do
      it "decrements the victim's score" do
        players = {}
        described_class.update_scores(players, '<world>', 'Jane')
        expect(players).to eq({'Jane' => -1})
      end
    end
  end

  describe ".update_death_causes" do
    it "updates the count of death causes" do
      deaths_by_cause = {}
      described_class.update_death_causes(deaths_by_cause, 'MOD_ROCKET')
      expect(deaths_by_cause).to eq({'MOD_ROCKET' => 1})
    end
  end

  describe ".process_match" do
    it "compiles match data including total kills, player scores, and death causes" do
      match = ["InitGame:", "20:34 Kill: 2 3 7: John killed Jane by MOD_ROCKET"]
      result = described_class.process_match(match)
      expect(result).to include(
        total_kills: 1,
        players: {'John' => 1, 'Jane' => 0},
        deaths_by_cause: {'MOD_ROCKET' => 1}
      )
    end
  end
end
