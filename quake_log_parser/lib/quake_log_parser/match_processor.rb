module QuakeLogParser
    class MatchProcessor
      def self.get_match_indexes(log)
        log.each_with_index.select { |line, _| line.include?('InitGame:') }.map(&:last)
      end
  
      def self.get_match_list(log, indexes)
        indexes.map.with_index do |start_idx, i|
          end_idx = i < indexes.size - 1 ? indexes[i + 1] : log.size
          log[start_idx...end_idx]
        end
      end
  
      def self.parse_kill_line(line)
        killer = line[/\d+:\d+ Kill: \d+ \d+ \d+: (.*?) killed/, 1].strip
        victim = line[/killed (.*?) by/, 1].strip
        method = line[/by (\w+)$/, 1]
        [killer, victim, method]
      end
  
      def self.update_scores(players, killer, victim)
        players[victim] ||= 0
  
        if killer == '<world>'
          players[victim] -= 1
        else
          players[killer] ||= 0
          players[killer] += 1
        end
        players
      end
  
      def self.update_death_causes(deaths_by_cause, method)
        deaths_by_cause[method] ||= 0
        deaths_by_cause[method] += 1
        deaths_by_cause
      end
  
      def self.process_match(match)
        players = {}
        deaths_by_cause = {}
        total_kills_amount = 0
  
        match.each do |line|
          next unless line.include?("Kill:")
          
          total_kills_amount += 1
          killer, victim, method = parse_kill_line(line)
          players = update_scores(players, killer, victim)
          deaths_by_cause = update_death_causes(deaths_by_cause, method)
        end
  
        {
          total_kills: total_kills_amount,
          players: players,
          deaths_by_cause: deaths_by_cause
        }
      end
    end
  end
  