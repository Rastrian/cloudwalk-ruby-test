require 'json'

def safe_read_log(file_path)
  lines = File.readlines(file_path)
  raise "File is empty" if lines.empty?
  lines
rescue Errno::ENOENT
  puts "File not found: Ensure the file path is correct."
  exit
rescue Exception => e
  puts "An unexpected error occurred: #{e.message}"
  exit
end

def get_match_indexes(log)
  log.each_with_index.select { |line, _| line.include?('InitGame:') }.map(&:last)
end

def get_match_list(log, indexes)
  indexes.map.with_index do |start_idx, i|
    end_idx = i < indexes.size - 1 ? indexes[i + 1] : log.size
    log[start_idx...end_idx]
  end
end

def parse_kill_line(line)
  killer = line[/\d+:\d+ Kill: \d+ \d+ \d+: (.*?) killed/, 1].strip
  victim = line[/killed (.*?) by/, 1].strip
  method = line.split.last
  [killer, victim, method]
end

def update_scores(players, killer, victim)
  players[victim] = (players[victim] || 0) - 1 if killer == '<world>'
  players[killer] = (players[killer] || 0) + 1 unless killer == '<world>'
  players
end

def update_death_causes(deaths_by_cause, method)
  deaths_by_cause[method] = (deaths_by_cause[method] || 0) + 1
  deaths_by_cause
end

def process_match(match)
  players, deaths_by_cause = {}, {}
  total_kills_amount = 0
  total_kills_amount_by_players = 0
  total_kills_amount_by_world = 0

  match.each do |line|
    if line.include?("Kill:")
      total_kills_amount += 1
      killer, victim, method = parse_kill_line(line)
      total_kills_amount_by_players += 1 unless killer == '<world>'
      total_kills_amount_by_world += 1 if killer == '<world>'
      players = update_scores(players, killer, victim)
      deaths_by_cause = update_death_causes(deaths_by_cause, method)
    end
  end

  {
    total_kills: players.values.sum,
    total_kills_amount: total_kills_amount,
    total_kills_amount_by_players: total_kills_amount_by_players,
    total_kills_amount_by_world: total_kills_amount_by_world,
    players: players.keys - ['<world>'],
    kills: players,
    deaths_by_cause: deaths_by_cause
  }
end

def generate_report(file_path)
  log_lines = safe_read_log(file_path)
  match_indexes = get_match_indexes(log_lines)
  match_list = get_match_list(log_lines, match_indexes)
  games = match_list.map { |match| process_match(match) }
  JSON.pretty_generate(games)
end

file_path = ARGV[0] || '../quake.log'
puts generate_report(file_path)
