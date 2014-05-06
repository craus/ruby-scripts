def sample x,y, game
  game.new(x, y).play
end

def play tactic1, tactic2, game, n = 1
  score = {0 => 0, 1 => 0, nil => 0}
  n.times do 
    game.new(tactic1, tactic2).play
    score[game.last.result] += 1
  end
  score
end

def stat x,y,n=90000
  $silent = true
	score = play x, y, n
	puts "#{score} (#{'+' if score[0] > score[1]}#{score[0]-score[1]})"
end

def sum score
  score[0] + score[1]
end

def rnd_delta score, k
  k * Math.sqrt(sum(score))
end

def delta score
	score[0]-score[1]
end

def cnt score
  score[0]+score[1]+score[nil]
end

def report score, k
	puts "#{score}"
	puts "#{'+' if score[0] > score[1]}#{delta(score)} of #{cnt(score)} (winrate #{[-1,1].map{|d|((score[0]+d*rnd_delta(score, k)/2) * 100.0 / sum(score) - 50).round(2).with_sign}.join('..')} %)"
	puts count_errors(delta(score).abs / Math.sqrt(sum(score)))
end

def report_tactics x,y
	[x,y].each do |t|
		if t.class < Hash 
			t.each_pair do |key, value|
				puts "tactic[#{key}] = #{value}"
			end
		end
	end
end

def compare x,y, game, report_period = 10000, k = 4, n = 10000000000
  puts title="Comparison #{x} and #{y}"
  $silent = true
  score = {0 => 0, 1 => 0, nil => 0}
  n.times do 
    game.new(x, y).play
    score[game.last.result] += 1
		if delta(score).abs > rnd_delta(score, k)
			break
		end
		if cnt(score) % report_period == 0
			report score, k
			report_tactics x,y
		end
  end
	
	report score, k
	report_tactics x,y
	puts "\a" + "\n" * 20 if cnt(score) > 100000
	puts title + ' finished.'
end

def count_errors k, n = 10000, m = 100
	$silent = true
	max_delta = Math.sqrt(m) * k
	cnt = 0
	n.times do
		score = (0...m).to_a.map{Random.rand(2)}.inject :+
		cnt += 1 if (score-(m-score)).abs >= max_delta
	end
	1.0 * cnt / n
end