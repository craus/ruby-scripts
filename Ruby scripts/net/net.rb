N = 100
K = 5

node = []
N.times {node << rand}

link = {}
(N*K).times {link[[rand(N),rand(N)]] = rand}

link.each{|k,v| puts "#{k[0]} - #{k[1]}: #{v}"}

