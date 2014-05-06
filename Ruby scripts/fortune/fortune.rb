def d x
  "(#{x>0 ? "+#{x}" : "#{x}"})"
end

{mana: 80, life: 100, enemies: 0, weapon: 1}.each do |param, value|
  eval %Q{
		@#{param} = #{value}
		def #{param} x = 0		
			x = -@#{param} if x < -@#{param}			
			return @#{param} if x == 0	
			@#{param} += x
			puts "#{param.capitalize} \#{@#{param}} \#{d(x)}"
		end
		def #{param}? x
		  res = @#{param} >= x
			puts "Not enough #{param}: \#{@#{param}}, need \#{x}" unless res
			#{param} -x
			res
		end
  }
end

def move
  case gets
	  when 'r' then mana(+50)

		else puts 'wtf?'
	end
end

def chance n
  yield if rand(n) == 0
end

def run
  chance(2) { mana -1; return }
	chance(2) { life -enemies; return }
	chance(2) { enemies +1; return }
	chance(2) { move; return }
	gets
end

loop { run }
