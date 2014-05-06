@p = {}

EPS = 1e-9

def fight x, y
	while x>0 && y>0
		if rand(x+y)<x
			y -= 1
		else
			x -= 1
		end
	end
	x-y
end

def fight_det x, y, d = 1.5-Math.sqrt(5)/2
  x -= (y*d).round
	move = :x
	while x>0 && y>0
	  if move == :x
		  y -= x
			move = :y
		else
		  x -= y
			move = :x
		end
	end
	x = [0,x].max
	y = [0,y].max
	x-y
end

def prob x, y, r
	@p[[x,y,r]] ||= (x == 0 ? (y == -r ? 1 : 0) : (y == 0 ? (x == r ? 1 : 0) : (0.0 + prob(x,y-1,r) * x + prob(x-1,y,r) * y) / (x+y)))	  
end

def most_probable
	if ARGV.size == 1 
		m = (ARGV[0]||'10').to_i
		1.upto(m) do |x|
			1.upto(m) do |y|
				a = []
				(-y).upto(x) {|r| a << [prob(x,y,r),r] unless prob(x,y,r) == 0}
				a.sort!.reverse!
				puts "#{x} vs #{y}:"
				a.first(10).each { |(p,r)| puts "#{p*100}% : #{r}" }	
				puts
			end
		end
	elsif ARGV.size == 2
		x,y = ARGV.map(&:to_i)
		puts fight(x,y)
	end
end

def dice_outcome
	if ARGV.size == 1 
		m = (ARGV[0]||'10').to_i
		1.upto(m) do |x|
			1.upto(m) do |y|
				a = []
				(-y).upto(x) {|r| a << [r, prob(x,y,r)] unless prob(x,y,r) == 0}
				a.sort!
				puts "#{x} vs #{y}:"
				p_dice = 1.0/12
				dice = 1
				p_cur = 0.0
				a.each do |(r,p)|
				  p_cur += p
					#puts p_cur
				  while dice <= 3 && p_cur > p_dice - EPS || dice >= 4 && p_cur > p_dice + EPS
						puts "outcome #{dice}: #{r} (#{})"
						p_dice += 1.0/6
						dice += 1
					end
				end
				puts
			end
		end
	elsif ARGV.size == 2
		x,y = ARGV.map(&:to_i)
		puts fight(x,y)
	end
end

def fight_det_results m = 30
	1.upto(m) do |x|
		1.upto(m) do |y|
			print "#{'%3d' % x}:#{'%3d' % y}=#{'%3d' % fight_det(x,y)}   "
		end
		puts
	end
end



fight_det_results