@auction = {}

def auction things, players, target = nil
  if things.class == Array 
	  new_things = Hash.new 0
		things.each { |t| new_things[t] += 1 }
		things = new_things
	end
	(@auction ||= {})[[things, players, target]] ||= begin
		forget = [target ? auction(things, [players[0], players[1]-target[1]], nil)[0] - target[0] : -1.0 / 0, :forget]
		raise = [-1.0 / 0, :raise]
		if target 
		  ((target[1]+1)..players[0]).reverse_each do |bet|
			  raise = [raise, [-auction(things, [players[1], players[0]], [target[0], bet])[0], [:raise, bet]]].max_by &:first
			end
		end
		select = [-1.0 / 0, :select]
		if target == nil
		  things.each_key do |thing|
				new_things = things.dup
				new_things[thing] -= 1
				new_things.delete thing if new_things[thing] == 0
				(0..players[0]).reverse_each do |bet|
					select = [select, [-auction(new_things, [players[1], players[0]], [thing, bet])[0], [:select, thing, bet]]].max_by &:first
				end
			end
		end
		stop = [things.empty? && target == nil ? 0 : -1.0 / 0, :stop]
		[forget, raise, select, stop].max_by &:first
	end
end

def rec x
  (@rec ||= {})[x] ||= begin
	  puts "calc"
		x <= 1 ? 1 : rec(x-1)+rec(x-2)
	end
end


puts auction([10,20,22], [3,3]).inspect