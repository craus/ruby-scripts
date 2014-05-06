def play
  life = 3
	time = 0
	while life > 0 
	  time += 1
	  life -= 1 if rand(1000) < 100
		life += 1 if rand(1000) < 90
		puts "got #{time} with #{life}" if time % 1000000 == 0
	end
	time
end

sum = 0
max_res = 0
distr = [0]*100000
d = 1
max_len = 100

(n=ARGV[0].to_i).times do |i|
	res = play
	max_res = [max_res,res].max
	puts res if n <= 50
	puts "#{i} done" if i%1000 == 0
	distr[res/d] += 1
	sum += res 
end

max_cnt = distr.max

max_i = max_res/d+1

puts "Average: #{sum/n}"
puts "Max: #{max_res}"

file = File.open('output.txt', 'w') do |f|
	
	f.puts "Average: #{sum/n}"
	f.puts "Max: #{max_res}"
	f.puts
	
	0.upto(max_i) do |i|
		next if distr[i,d].inject(:+) == 0
		f.print "#{"%04d" % (i*d)} - #{"%04d" % ((i+1)*d-1)}: #{"%04d" % distr[i,d].inject(:+)} " 
		((distr[i,d].inject(:+)*max_len+max_cnt/2)/max_cnt).times { f.print '*' }
		f.puts
	end

	(max_i*d).upto(max_res) do |res|
		distr[res].times { f.puts res }
	end
	
end

  
	
	
	
	
	
	
