if (c = ARGV[0]) == 'generate'
	File.open(ARGV[1], 'w') {|f| f.write((0...ARGV[2].to_i).to_a.shuffle.join(' ')) } 
elsif c =~ /(un|)crypt/
	p,s = IO.read(ARGV[3]).split.map(&:to_i),IO.read(ARGV[1])
	p = (0...p.size).to_a.map{|i| p.index i} if (un = (c == 'uncrypt'))
	r = (s + 0.chr * (-s.size % p.size)).scan(Regexp.new('.'*p.size,4)).map{|a| p.map{|x| a[x]}}.join
	File.open(ARGV[2], 'w') {|f| f.write un ? r.split(0.chr)[0] : r }
else
	p "unknown command: #{c.inspect}"
end